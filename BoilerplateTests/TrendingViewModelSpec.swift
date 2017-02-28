//
//  TrendingViewModelSpec.swift
//  Boilerplate
//
//  Created by Leo on 2/24/17.
//  Copyright © 2017 Leo. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxTest
import RxSwift
import RxCocoa
import Moya
@testable import Boilerplate

class TrendingViewModelSpec: QuickSpec {
    
    override func spec() {
        var sut: TrendingViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "SearchResponse", ofType: "json") else {
            fatalError("Invalid path for json file")
        }
        stubJsonPath = path
        
        beforeEach {
            GithubProvider = RxMoyaProvider<GitHub>(
                stubClosure:MoyaProvider.immediatelyStub,
                plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]
            )
            
            scheduler = TestScheduler(initialClock: 0)
            driveOnScheduler(scheduler) {
                sut = TrendingViewModel()
            }
            
            disposeBag = DisposeBag()
        }
        
        afterEach {
            scheduler = nil
            sut = nil
            disposeBag = nil
        }
        
        it("returns one repo when created") {
            let observer = scheduler.createObserver([Repository].self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.elements.asObservable()
                    .subscribe(observer)
                    .addDisposableTo(disposeBag)
            }
            
            scheduler.scheduleAt(200) {
               sut.inputs.loadPageTrigger.onNext(())
            }
            
            scheduler.start()

            let results = observer.events.last
                .map { event in
                    event.value.element!.count
            }
            
            expect(results) == 1
        }
        
        
        it("fetches repos when triggered refresh") {
            let observer = scheduler.createObserver([Repository].self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.elements.asObservable().subscribe(observer).addDisposableTo(disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.inputs.loadPageTrigger.onNext(())
            }
            
            scheduler.start()
            
            let numberOfCalls = observer.events
                .map { event in
                    event.value.element!.count
                }
                .reduce(0) { $0 + $1 }
            
            expect(numberOfCalls) == 1
        }

        
        
    }
}
