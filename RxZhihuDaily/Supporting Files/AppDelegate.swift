//
//  AppDelegate.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit
import HYSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupInitial(window: &window, rootViewController: HomeViewController(params: [:]), withNavigation: true)
        return true
    }
    
    func setupRouter() {
        Router.shared.register(aClass: StoryDetailViewController.self, for: "detail")
    }
    
}
