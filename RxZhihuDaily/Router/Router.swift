//
//  Router.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit
import HYSwift

class Router {
    
    static let shared = Router()
    private init() {}
    private var dynamicPages = [String: String]()
    func register(aClass:Routable.Type, for schema: String) {
        dynamicPages[schema] = NSStringFromClass(aClass)
    }
    
    enum DisplayStyle {
        case push, present
    }
    
    func open(url: URL?, params:[String: Any], displayStyle: DisplayStyle = .push) {
        guard let scheme = url?.scheme, let vcClass = dynamicPages[scheme] else {
            return
        }
        let routableClass = NSClassFromString(vcClass) as! Routable.Type
        let vc = routableClass.init(params: params)
        switch displayStyle {
        case .present:
            UIViewController.topController()?.present(vc, animated: true, completion: nil)
        case .push:
            UIViewController.navController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

protocol Routable: UIViewController {
    init(params: [String: Any])
}
