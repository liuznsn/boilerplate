//
//  RepoViewModel.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public protocol RepoViewModelInputs {
}

public protocol RepoViewModelOutputs {
    var isLoading: Driver<Bool> { get }
    var dataObservable: Driver<[RepositorySectionViewModel]> { get }
    var fullName: String {  get }
    var description: String {  get }
    var forksCounts: String {  get }
    var starsCount: String {  get }
}

public protocol RepoViewModelType {
    var inputs: RepoViewModelInputs { get  }
    var outputs: RepoViewModelOutputs { get }
}

public class RepoViewModel: RepoViewModelType, RepoViewModelInputs, RepoViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    init(repo:Repository) {
        
        let Loading = ActivityIndicator()
        self.isLoading = Loading.asDriver()

        
        self.repo = repo
        
        let lastThreePullsObservable = GithubProvider.rx.request(GitHub.Pulls(fullname: repo.fullName))
            .mapArray(Pull.self)
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: [])
            .map { (pulls:[Pull]) -> RepositorySectionViewModel in
                let itemsObjs = Array(pulls.prefix(3))
                let items = itemsObjs.map{ (pull:Pull) -> RepositoryCellViewModel in
                    return RepositoryCellViewModel(title:pull.title! , subtitle: "by " + (pull.user?.login)!)
                }
                return RepositorySectionViewModel(header: "Last three pull requests", items: items)
        }
        
        let lastThreeIssuesObservable = GithubProvider.rx.request(GitHub.Issues(fullname: repo.fullName))
            .mapArray(Issues.self)
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: [])
            .map { (issues:[Issues]) -> RepositorySectionViewModel in
                let itemsObjs = Array(issues.prefix(3))
                let items = itemsObjs.map{ (issue:Issues) -> RepositoryCellViewModel in
                    return RepositoryCellViewModel(title:issue.title! , subtitle: "by " + (issue.user?.login)!)
                }
                return RepositorySectionViewModel(header: "Last three issues", items: items)
        }
        
        let lastThreeCommitsObservable = GithubProvider.rx.request(GitHub.Commits(fullname: repo.fullName))
            .mapArray(Commits.self)
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: [])
            .map { (commits:[Commits]) -> RepositorySectionViewModel in
                let itemsObjs = Array(commits.prefix(3))
                let items = itemsObjs.map{ (commit:Commits) -> RepositoryCellViewModel in
                    
                    return RepositoryCellViewModel(title:(commit.commit?.message)!,
                                                  subtitle: "by " + (commit.commit?.author?.name == nil ? "" : (commit.commit?.author?.name)!))
                }
                return RepositorySectionViewModel(header: "Last three commits", items: items)
        }
        
        self.dataObservable = Driver.zip(lastThreePullsObservable, lastThreeIssuesObservable, lastThreeCommitsObservable) {
            [$0, $1, $2].filter { !$0.items.isEmpty }
        }

        _ = self.dataObservable
            .debug()
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: [])
    
        
    }
    
    public var isLoading: Driver<Bool>
    public var repo:Repository
    public var fullName: String { return repo.fullName }
    public var description: String { return repo.descriptionField }
    public var forksCounts: String { return String( repo.forksCount ) }
    public var starsCount: String { return String( repo.stargazersCount ) }
    public var dataObservable:Driver<[RepositorySectionViewModel]>
    public var inputs: RepoViewModelInputs { return self}
    public var outputs: RepoViewModelOutputs { return self}
}


public struct RepositorySectionViewModel {
    let header: String
    let items: [RepositoryCellViewModel]
}

public struct RepositoryCellViewModel {
    let title: String
    let subtitle: String
}
