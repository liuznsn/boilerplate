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
    func refresh()
    func tapped(indexRow: Int)
    func keyword(keyword: String)
    
    var loadPageTrigger: PublishSubject<Void> { get }
    var loadNextPageTrigger: PublishSubject<Void> { get }
}

public protocol TrendingViewModelOutputs {
    var isLoading: Driver<Bool> { get }
    var moreLoading: Driver<Bool> { get }
    var elements: BehaviorRelay<[Repository]> { get }
    var selectedViewModel: Driver<RepoViewModel> { get }
}

public protocol TrendingViewModelType {
    var inputs: TrendingViewModelInputs { get  }
    var outputs: TrendingViewModelOutputs { get }
}

public class TrendingViewModel: TrendingViewModelType, TrendingViewModelInputs, TrendingViewModelOutputs {
    
    // MARK: - Private properties 🕶
    private var keyword = ""
    private var pageIndex: Int = 1
    private let disposeBag = DisposeBag()
    private let error = PublishSubject<Swift.Error>()
    
    // MARK: - Visible properties 👓
    let repository = BehaviorRelay<Repository?>(value: nil)
    
    public var isLoading: Driver<Bool>
    public var moreLoading: Driver<Bool>
    public var elements: BehaviorRelay<[Repository]>
    
    public var loadPageTrigger: PublishSubject<Void>
    public var loadNextPageTrigger: PublishSubject<Void>
    
    public var selectedViewModel: Driver<RepoViewModel>
    public var inputs: TrendingViewModelInputs { return self}
    public var outputs: TrendingViewModelOutputs { return self}
    
    // MARK: - Constructor 🏗
    init() {
        
        let Loading = ActivityIndicator()
        self.isLoading = Loading.asDriver()
        let moreLoading = ActivityIndicator()
        self.selectedViewModel = Driver.empty()
        self.moreLoading = moreLoading.asDriver()
        
        self.loadPageTrigger = PublishSubject<Void>()
        self.loadNextPageTrigger = PublishSubject<Void>()
        
        self.elements = BehaviorRelay<[Repository]>(value: [])
        
        // First time load date
        let loadRequest = self.isLoading.asObservable()
            .sample(self.loadPageTrigger)
            .flatMap { isLoading -> Observable<[Repository]> in
                if isLoading {
                    return Observable.empty()
                } else {
                    self.pageIndex = 1
                    self.elements.accept([])
                    return API.sharedAPI.recentRepositories(self.keyword, page: self.pageIndex)
                        .trackActivity(Loading)
                }
        }
        
        // Get more data by page
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
        
        let request = Observable.of(loadRequest, nextRequest)
            .merge()
            .share(replay: 1)
        
        let response = request.flatMap { repositories -> Observable<[Repository]> in
            request
                .do(onError: { _error in
                    self.error.onNext(_error)
                }).catchError({ error -> Observable<[Repository]> in
                    Observable.empty()
                })
            }.share(replay: 1)
        
        // combine data when get more data by paging
        Observable
            .combineLatest(request, response, elements.asObservable()) { request, response, elements in
                return self.pageIndex == 1 ? response : elements + response
            }
            .sample(response)
            .bind(to: elements)
            .disposed(by: disposeBag)
        
        //binding selected item
        self.selectedViewModel = self.repository.asDriver().filterNil().flatMapLatest{ repo -> Driver<RepoViewModel> in
            return Driver.just(RepoViewModel(repo: repo))
        }
    }
    
    public func refresh() {
        self.loadPageTrigger
            .onNext(())
    }
    
    public func tapped(indexRow: Int) {
        let repository = self.elements.value[indexRow]
        self.repository.accept(repository)
    }
    
    public func keyword(keyword: String) {
        self.keyword = keyword
    }
}
