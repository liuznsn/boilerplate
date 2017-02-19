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


public class GitHubDefaultValidationService: GitHubValidationService {
    
    static let sharedValidationService = GitHubDefaultValidationService()
    
    public func validateEmail(_ email: String) -> Observable<ValidationResult> {
        if email.characters.count == 0 {
            return .just(.empty)
        } else {
            return .just(.ok(message: "Username available"))
        }
    }
    
    public func validatePassword(_ password: String) -> ValidationResult {
        if password.characters.count == 0 {
            return .empty
        } else {
            return .ok(message: "Password acceptable")
        }
    }
    
}

public class API:GitHubAPI {
    
    static let sharedAPI = API()
    
    public func signin(_ username: String, password: String) -> Observable<Bool>{
       return GithubProvider.request(GitHub.Token(username: username, password: password))
            .mapObject(Authorizations.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { author -> Observable<Bool> in
                if author.token == nil{
                return Observable.just(false)
               } else{
                    var environment = Environment()
                    environment.token = author.token
                   return Observable.just(true)
               }
            }
    }
    
    public func repositories(_ keyword:String, page:Int) -> Observable<[Repository]> {
        return GithubProvider.request(GitHub.RepoSearch(query: keyword,page:page))
            .mapObject(Repositories.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest{ repositories -> Observable<[Repository]> in
                guard let items = repositories.items else {
                    return Observable.empty()
                }
                return Observable.just(items)
            }
        
    }
    
    public func recentRepositories(_ language:String, page:Int) -> Observable<[Repository]> {
        return GithubProvider.request(GitHub.TrendingReposSinceLastWeek(language: language, page: page))
            .mapObject(Repositories.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest{ repositories -> Observable<[Repository]> in
                guard let items = repositories.items else {
                    return Observable.empty()
                }
                return Observable.just(items)
        }
        
    }
    
    public func profile() -> Observable<User> {
        return GithubProvider.request(GitHub.User)
               .mapObject(User.self)
               .observeOn(MainScheduler.instance)
               .flatMapLatest{ user -> Observable<User> in
                  return Observable.just(user)
               }
    }
    
}


func isLoading(for view: UIView) -> AnyObserver<Bool> {
    return UIBindingObserver(UIElement: view, binding: { (hud, isLoading) in
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


