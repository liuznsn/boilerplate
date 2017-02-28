//
//  LoginViewModel.swift
//  LIFE
//
//  Created by Leo on 2017/2/7.
//  Copyright © 2017年 Leo. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift
import Result
import Moya
import Moya_ObjectMapper
import RxOptional
import RxDataSources

private let disposeBag = DisposeBag()

public protocol LoginViewModelInputs {
    
    var email:PublishSubject<String?>{ get}
    var password:PublishSubject<String?>{ get }
    var loginTaps:PublishSubject<Void>{ get }
}

public protocol LoginViewModelOutputs {
    
    var validatedEmail: Driver<ValidationResult> { get }
    var validatedPassword: Driver<ValidationResult> { get }
    var enableLogin: Driver<Bool>{ get }
    var signedIn: Driver<Bool> { get }
    var isLoading: Driver<Bool> { get }
    
}

public protocol LoginViewModelType {    
    var inputs: LoginViewModelInputs { get  }
    var outputs: LoginViewModelOutputs { get }
}

public class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
    
    public init() {
        self.email = PublishSubject<String?>()
        self.password = PublishSubject<String?>()
        self.loginTaps = PublishSubject<Void>()
        
        let validationService = GitHubDefaultValidationService.sharedValidationService
        
        self.validatedEmail = self.email.asDriver(onErrorJustReturn: nil).flatMapLatest{ email in
            return validationService.validateUserid(email!)
                .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
        }
        
        self.validatedPassword = self.password.asDriver(onErrorJustReturn: nil).map{ password in
            return validationService.validatePassword(password!)
        }
        
        self.enableLogin = Driver.combineLatest(
            validatedEmail,
            validatedPassword) { email, password in
                return email.isValid && password.isValid
        }
        
        let emailAndPassword = Driver.combineLatest(self.email.asDriver(onErrorJustReturn: nil),
                                                    self.password.asDriver(onErrorJustReturn: nil)) { ($0,$1)  }
        
        let isLoading = ActivityIndicator()
        self.isLoading = isLoading.asDriver()

        self.signedIn = self.loginTaps
            .asDriver(onErrorJustReturn:())
            .withLatestFrom(emailAndPassword)
            .flatMapLatest{ (email,password) in
           
                return API.sharedAPI
                    .signin(email!, password: password!)
                    .trackActivity(isLoading)
                    .asDriver(onErrorJustReturn: false)
                
          }
        
    }
    
    public var validatedEmail: Driver<ValidationResult>
    public var validatedPassword: Driver<ValidationResult>
    public var enableLogin: Driver<Bool>
    public var loginTaps: PublishSubject<Void>
    public var password: PublishSubject<String?>
    public var email: PublishSubject<String?>
    public var signedIn: Driver<Bool>
    public var isLoading: Driver<Bool>
    public var inputs: LoginViewModelInputs { return self}
    public var outputs: LoginViewModelOutputs { return self}
    
}





