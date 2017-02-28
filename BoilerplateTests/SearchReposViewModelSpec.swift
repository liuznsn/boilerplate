//
//  SearchReposViewModelSpec.swift
//  Boilerplate
//
//  Created by Leo on 2/28/17.
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

class SearchReposViewModelSpec: QuickSpec {

    override func spec() {
        
        var sut: SearchReposViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        
        beforeEach {
        
            let bundle = Bundle(for: type(of: self))
            guard let path = bundle.path(forResource: "SearchResponse", ofType: "json") else {
                fatalError("Invalid path for json file")
            }
            stubJsonPath = path
            
            
            GithubProvider = RxMoyaProvider<GitHub>(
                stubClosure:MoyaProvider.immediatelyStub,
                plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]
            )
            
            
            scheduler = TestScheduler(initialClock: 0)
            driveOnScheduler(scheduler) {
                sut = SearchReposViewModel()
            }
            
            disposeBag = DisposeBag()
        }
        
        afterEach {
            scheduler = nil
            sut = nil
            disposeBag = nil
        }
        
        xit("returns one repo when queried") {
            let observer = scheduler.createObserver([Repository].self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.elements.asObservable()
                    .subscribe(observer)
                    .addDisposableTo(disposeBag)
            }

            
            scheduler.scheduleAt(200) {
                sut.inputs.searchKeyword.onNext("swift")

            }
            
            scheduler.start()
            
            let results = observer.events.first
                .map { event in
                    event.value.element!.count
                }
            
            expect(results) == 1

        }
        
    }
}
