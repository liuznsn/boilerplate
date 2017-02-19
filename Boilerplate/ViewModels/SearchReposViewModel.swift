//
//  SearchReposViewModel.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/13.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


public protocol SearchReposViewModelInputs {
    var searchKeyword:PublishSubject<String?> { get }
    var loadNextPageTrigger:PublishSubject<Void> { get }
    func tapped(repository: Repository)

}

public protocol SearchReposViewModelOutputs {
    var isLoading: Driver<Bool> { get }
    var elements:Variable<[Repository]> { get }
    var selectedViewModel: Driver<RepoViewModel> { get }
}

public protocol SearchReposViewModelType {
    var inputs: SearchReposViewModelInputs { get  }
    var outputs: SearchReposViewModelOutputs { get }
}

public class SearchReposViewModel: SearchReposViewModelType, SearchReposViewModelInputs, SearchReposViewModelOutputs {

    private let disposeBag = DisposeBag()
    private let error = PublishSubject<Swift.Error>()
    private var pageIndex:Int = 1
    private var query:String = ""
    init() {
        self.selectedViewModel = Driver.empty()
        self.searchKeyword = PublishSubject<String?>()
        self.loadNextPageTrigger = PublishSubject<Void>()
        self.elements = Variable<[Repository]>([])
        let isLoading = ActivityIndicator()
        self.isLoading = isLoading.asDriver()

        
        let keywordRequest = self.searchKeyword.asDriver(onErrorJustReturn: "")
            .throttle(0.3)
            .distinctUntilChanged()
            .flatMap { query -> Driver<[Repository]> in
                self.query = query!
                return API.sharedAPI.repositories(query!, page: self.pageIndex)
                    .trackActivity(isLoading)
                    .asDriver(onErrorJustReturn: [])
        }

        
        let nextPageRequest = isLoading
            .asObservable()
            .sample(self.loadNextPageTrigger)
            .flatMap { _isLoading -> Driver<[Repository]> in
                if _isLoading.hashValue == 0 && self.query != "" {
                    self.pageIndex = self.pageIndex + 1
                return API.sharedAPI.repositories(self.query, page: self.pageIndex)
                    .trackActivity(isLoading)
                    .asDriver(onErrorJustReturn: [])
                }
             return Driver.empty()
        }
        
        
        let request = Observable.of(keywordRequest.asObservable(),nextPageRequest)
                      .merge()
                      .shareReplay(1)
        
        
        let response = request.flatMap { repositories -> Observable<[Repository]> in
            request
                .do(onError: { _error in
                    self.error.onNext(_error)
                }).catchError({ error -> Observable<[Repository]> in
                    Observable.empty()
                })
            }.shareReplay(1)
        
        Observable
            .combineLatest(request, response, elements.asObservable()) { request, response, elements in
                return self.pageIndex == 1 ? response : elements + response
            }
            .sample(response)
            .bindTo(elements)
            .addDisposableTo(disposeBag)

        self.selectedViewModel = self.repository.asDriver().filterNil().flatMapLatest{ repo -> Driver<RepoViewModel> in
            return Driver.just(RepoViewModel(repo: repo))
        }
    }
    
    let repository = Variable<Repository?>(nil)
    public func tapped(repository: Repository) {
        self.repository.value = repository
    }
    
    public var selectedViewModel: Driver<RepoViewModel>
    public var elements:Variable<[Repository]>
    public var isLoading: Driver<Bool>
    public var searchKeyword:PublishSubject<String?>
    public var loadNextPageTrigger:PublishSubject<Void>
    public var inputs: SearchReposViewModelInputs { return self}
    public var outputs: SearchReposViewModelOutputs { return self}
    
}
