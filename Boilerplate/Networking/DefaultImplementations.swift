//
//  DefaultImplementations.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

import RxSwift
import RxCocoa
import SVProgressHUD
import Moya
import RxCodable

public class GitHubDefaultValidationService: GitHubValidationService {
    
    static let sharedValidationService = GitHubDefaultValidationService()
    
    public func validateUserid(_ userid: String) -> Observable<ValidationResult> {
        if userid.count < 6 {
            return .just(.empty)
        } else {
            return .just(.ok(message: "Username available"))
        }
    }
    
    public func validatePassword(_ password: String) -> ValidationResult {
        if password.count == 0 {
            return .empty
        } else {
            return .ok(message: "Password acceptable")
        }
    }
    
}

public class API:GitHubAPI {
    
    static let sharedAPI = API()
    
    public func signin(_ username: String, password: String) -> Single<Bool> {
        return GithubProvider.rx.request(GitHub.Token(username: username, password: password))
               .map(Authorizations.self)
               .observeOn(MainScheduler.instance)
               .flatMap({ author -> Single<Bool> in
                    if author.token == nil{
                        return Single.just(false)
                    } else{
                        var environment = Environment()
                        environment.token = author.token
                        return Single.just(true)
                    }
               })
    }
    
    
    public func repositories(_ keyword:String, page:Int) -> Single<[Repository]> {
        return GithubProvider.rx.request(GitHub.RepoSearch(query: keyword,page:page))
            .map(Repositories.self)
            .observeOn(MainScheduler.instance)
            .flatMap({ repositories -> Single<[Repository]> in
                guard let items = repositories.items else {
                    return Single.just([])
                }
                return Single.just(items)
            })
    }
    

    public func recentRepositories(_ language:String, page:Int) -> Single<[Repository]> {
        return GithubProvider.rx.request(GitHub.TrendingReposSinceLastWeek(language: language, page: page))
            .map(Repositories.self)
            .observeOn(MainScheduler.instance)
            .flatMap({ repositories -> Single<[Repository]> in
                guard let items = repositories.items else {
                    return Single.just([])
                }
                return Single.just(items)
            })
    }

    public func profile() -> Single<User> {
        return GithubProvider.rx.request(GitHub.User)
            .map(User.self)
            .observeOn(MainScheduler.instance)
            .flatMap({ user -> Single<User> in
                 return Single.just(user)
            })
        
    }
}

func isLoading(for view: UIView) -> AnyObserver<Bool> {
    
    return Binder(view, binding: { (hud, isLoading) in
        switch isLoading {
        case true:
            SVProgressHUD.show()
        case false:
            SVProgressHUD.dismiss()
            break
        }
    }).asObserver()
}

//https://gist.github.com/brocoo/aaabf12c6c2b13d292f43c971ab91dfa
extension Reactive where Base: UIScrollView {
    public var reachedBottom: Observable<Void> {
        let scrollView = self.base as UIScrollView
        return self.contentOffset.flatMap{ [weak scrollView] (contentOffset) -> Observable<Void> in
            guard let scrollView = scrollView else { return Observable.empty() }
            let visibleHeight = scrollView.frame.height - self.base.contentInset.top - scrollView.contentInset.bottom
            let y = contentOffset.y + scrollView.contentInset.top
            let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
            return (y > threshold - (threshold / 4)) ? Observable.just(()) : Observable.empty()
        }
    }
}


