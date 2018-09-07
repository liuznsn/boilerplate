//
//  ProfileViewModel.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

public protocol ProfileViewModelInputs {
    var isLoading: Driver<Bool> { get }
    var logoutTaps: PublishSubject<Void> { get }
}

public protocol ProfileViewModelOutputs {
    var profileObservable: Observable<[ProfileSectionModel]> { get }
    var user: PublishSubject<User> { get }
    var logout: Driver<Bool> { get }
}

public protocol ProfileViewModelType {
    var inputs: ProfileViewModelInputs { get  }
    var outputs: ProfileViewModelOutputs { get }
}

public class ProfileViewModel: ProfileViewModelType, ProfileViewModelInputs, ProfileViewModelOutputs {
    
       private let disposeBag = DisposeBag()
    
    init() {
        self.profileObservable = Observable<[ProfileSectionModel]>.just([])
        self.user = PublishSubject<User>.init()
        let Loading = ActivityIndicator()
        self.isLoading = Loading.asDriver()
        self.logoutTaps = PublishSubject<Void>()
        self.logout = Driver.just(false)
        
        self.profileObservable = API.sharedAPI.profile()
            .trackActivity(Loading)
            .flatMap{ user -> Observable<[ProfileSectionModel]> in
                
                self.user.onNext(user)
                
                let profileSectionModel = ProfileSectionModel(model: "", items:
                    [Profile.avatar(title: "avatarUrl", avatarUrl: user.avatarUrl!)
                        ,Profile.detail(title: "id", detail: user.login!)
                    ]
                )
                
                return Observable.just([profileSectionModel])
            }
        
       self.logout = self.logoutTaps
                         .asDriver(onErrorJustReturn:())
                         .flatMapLatest{ _ -> Driver<Bool> in
                            let environment = Environment()
                            environment.remove()
                             return Driver.just(true)
                         }
        
    }
    
    public var isLoading: Driver<Bool>
    public var logoutTaps: PublishSubject<Void>
    public var user: PublishSubject<User>
    public var profileObservable: Observable<[ProfileSectionModel]>
    public var logout: Driver<Bool>
    public var inputs: ProfileViewModelInputs { return self}
    public var outputs: ProfileViewModelOutputs { return self}
}


