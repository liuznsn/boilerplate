//
//  TrendingViewCoordinator.swift
//  Boilerplate
//
//  Created by Leo on 2018/09/06.
//  Copyright © 2018 Leo. All rights reserved.
//

import UIKit
import RxSwift

class TrendingViewCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = TrendingViewModel()
        let viewController = TrendingViewController(itemInfo: "swift")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
}
