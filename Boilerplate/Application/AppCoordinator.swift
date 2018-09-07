//
//  AppCoordinator.swift
//  Boilerplate
//
//  Created by Leo on 2018/09/06.
//  Copyright © 2018 Leo. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        let environment = Environment()
        if !environment.tokenExists {
            let loginViewCoordinator = LoginViewCoordinator(window: window)
            return coordinate(to: loginViewCoordinator)
        }
        
        let rootTabBarCoordinator = RootTabBarCoordinator(window: window)
        return coordinate(to: rootTabBarCoordinator)
    }
   
}
