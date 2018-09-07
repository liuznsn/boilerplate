//
//  RootTabViewCoordinator.swift
//  Boilerplate
//
//  Created by Leo on 2018/09/06.
//  Copyright © 2018 Leo. All rights reserved.
//

import UIKit
import RxSwift

class RootTabBarCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        let tabBarController = UITabBarController()
        
        let searchReposViewController = SearchReposViewController()
        let segmentedViewController = SegmentedViewController()
        let profileViewController = ProfileViewController()
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: segmentedViewController),
            UINavigationController(rootViewController: searchReposViewController),
            UINavigationController(rootViewController: profileViewController)
        ]
        
        
        let trendingTabbaritem = UITabBarItem()
        trendingTabbaritem.icon(from: .Ionicon, code: "arrow-graph-up-right", iconColor: UIColor.gray, imageSize: CGSize.init(width: 25, height: 25), ofSize: 25)
        trendingTabbaritem.title = "Trending"
        let searchTabbaritem = UITabBarItem()
        searchTabbaritem.icon(from: .Ionicon, code: "ios-search-strong", iconColor: UIColor.gray, imageSize: CGSize.init(width: 25, height: 25), ofSize: 25)
        searchTabbaritem.title = "Search"
        let profileTabbaritem = UITabBarItem()
        profileTabbaritem.icon(from: .Ionicon, code: "person", iconColor: UIColor.gray, imageSize: CGSize.init(width: 25, height: 25), ofSize: 25)
        profileTabbaritem.title = "Profile"
        
        tabBarController.viewControllers?[0].tabBarItem = trendingTabbaritem
        tabBarController.viewControllers?[1].tabBarItem = searchTabbaritem
        tabBarController.viewControllers?[2].tabBarItem = profileTabbaritem
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .selected)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = UIColor.white
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
}
