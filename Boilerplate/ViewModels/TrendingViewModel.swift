//
//  TrendingViewModel.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public protocol TrendingViewModelInputs {
    var loadPageTrigger:PublishSubject<Void> { get }
    var loadNextPageTrigger:PublishSubject<Void> { get }
    func refresh()
    func tapped(repository: Repository)
    func keyword(keyword:String)
}

public protocol TrendingViewModelOutputs {
    var isLoading: Driver<Bool> { get }
    var moreLoading: Driver<Bool> { get }
    var elements:Variable<[Repository]> { get }
    var selectedViewModel: Driver<RepoViewModel> { get }
}

public protocol TrendingViewModelType {
    var inputs: TrendingViewModelInputs { get  }
    var outputs: TrendingViewModelOutputs { get }
}

public class TrendingViewModel: TrendingViewModelType, TrendingViewModelInputs, TrendingViewModelOutputs {

    private let disposeBag = DisposeBag()
    private var pageIndex:Int = 1
    private let error = PublishSubject<Swift.Error>()
    private var keyword = ""
    
    init() {
        self.selectedViewModel = Driver.empty()
        self.loadPageTrigger = PublishSubject<Void>()
        self.loadNextPageTrigger = PublishSubject<Void>()
        self.elements = Variable<[Repository]>([])
        let Loading = ActivityIndicator()
        self.isLoading = Loading.asDriver()
        let moreLoading = ActivityIndicator()
        self.moreLoading = moreLoading.asDriver()
        
        // first time load date
        let loadRequest = self.isLoading.asObservable()
            .sample(self.loadPageTrigger)
            .flatMap { isLoading -> Observable<[Repository]> in
                if isLoading {
                    return Observable.empty()
                } else {
                    self.pageIndex = 1
                    self.elements.value.removeAll()
                    return API.sharedAPI.recentRepositories(self.keyword, page: self.pageIndex)
                    .trackActivity(Loading)
                }
        }
        
        //get more data by page
        let nextRequest = self.moreLoading.asObservable()
             .sample(self.loadNextPageTrigger)
             .flatMap { isLoading -> Observable<[Repository]> in
                if isLoading {
                    return Observable.empty()
                } else {
                    self.pageIndex = self.pageIndex + 1
                    return API.sharedAPI.recentRepositories(self.keyword, page: self.pageIndex)
                        .trackActivity(moreLoading)
                }
        }
        
        let request = Observable.of(loadRequest,nextRequest)
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
        
        
        //combine data when get more data by paging
        Observable
            .combineLatest(request, response, elements.asObservable()) { request, response, elements in
                return self.pageIndex == 1 ? response : elements + response
            }
            .sample(response)
            .bindTo(elements)
            .addDisposableTo(disposeBag)
        
        //binding selected item
        self.selectedViewModel = self.repository.asDriver().filterNil().flatMapLatest{ repo -> Driver<RepoViewModel> in
           return Driver.just(RepoViewModel(repo: repo))
        }

    }
    
    public func refresh() {
        self.loadPageTrigger
            .onNext()

    }
    
    let repository = Variable<Repository?>(nil)
    public func tapped(repository: Repository) {
        self.repository.value = repository
    }
    
    public func keyword(keyword: String) {
        self.keyword = keyword
    }
    
    public var selectedViewModel: Driver<RepoViewModel>
    public var loadPageTrigger:PublishSubject<Void>
    public var loadNextPageTrigger:PublishSubject<Void>
    public var moreLoading: Driver<Bool>
    public var isLoading: Driver<Bool>
    public var elements:Variable<[Repository]>
    public var inputs: TrendingViewModelInputs { return self}
    public var outputs: TrendingViewModelOutputs { return self}

}
