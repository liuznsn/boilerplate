//
//  LoginViewModelSpec.swift
//  Boilerplate
//
//  Created by Leo on 2/28/17.
//  Copyright © 2017 Leo. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxSwift
import RxCocoa
import RxTest
import Moya

@testable import Boilerplate

class LoginViewModelSpec: QuickSpec {
 
    override func spec() {
        var sut: LoginViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        beforeEach {
            /*
            GithubProvider = RxMoyaProvider<GitHub>(
                stubClosure: MoyaProvider.immediatelyStub,
                plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)]
            )
            */
            scheduler = TestScheduler(initialClock: 0)
            driveOnScheduler(scheduler) {
                sut = LoginViewModel()
            }
            disposeBag = DisposeBag()
        }
        
        afterEach {
            scheduler = nil
            sut = nil
            disposeBag = nil
        }
        
        it("should enable UI elements when valid login credentials are entered") {
            let observer = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.enableLogin.asObservable().subscribe(observer).addDisposableTo(disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.inputs.email.onNext("abcdefg")
                sut.inputs.password.onNext("abcdefg")
            }
            
            scheduler.start()
            
            let results = observer.events
                .map { event in
                    event.value.element!
            }
            
            expect(results) == [true]
        }
        
        it("should not enable UI elements when invalid credentials are entered") {

            let observer = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.enableLogin.asObservable().subscribe(observer).addDisposableTo(disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.inputs.email.onNext("a")
                sut.inputs.password.onNext("a")
            }
            
            scheduler.start()
            
            let results = observer.events
                .map { event in
                    event.value.element!
            }
            
            expect(results) == [false]
        }
        
    }

}
