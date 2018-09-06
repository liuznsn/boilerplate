//
//  LoginViewCoordinator.swift
//  Boilerplate
//
//  Created by Leo on 2018/09/06.
//  Copyright © 2018 Leo. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class LoginViewCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewController.viewModel.outputs.signedIn
            .drive(onNext: { signedIn in
                if signedIn ==  true {
                    let rootTabBarCoordinator = RootTabBarCoordinator(window: self.window)
                    self.coordinate(to: rootTabBarCoordinator)
                        .subscribe()
                        .disposed(by: self.disposeBag)
                } else {
                    SVProgressHUD.showError(withStatus: "Login Error")
                }
            }).disposed(by: disposeBag)
        
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
}
