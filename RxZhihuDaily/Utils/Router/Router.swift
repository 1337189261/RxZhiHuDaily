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
    private var dynamicPages = [String: Routable.Type]()
    func register(type:Routable.Type, for schema: String) {
        dynamicPages[schema] = type
    }
    
    enum DisplayStyle {
        case push, present
    }
    
    func open(url: URL?, params:[String: Any], displayStyle: DisplayStyle = .push) {
        guard let scheme = url?.scheme, let type = dynamicPages[scheme] else {
            return
        }
        let vc = type.init(params: params)
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
