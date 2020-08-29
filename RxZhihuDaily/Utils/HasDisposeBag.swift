//
//  HasDisposeBag.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import Foundation
import RxSwift
fileprivate var HasDisposeBagKey = "HasDisposeBagKey"
protocol HasDisposeBag: NSObject {
    
}
extension HasDisposeBag {
    var bag: DisposeBag {
        get {
            if let bag = objc_getAssociatedObject(self, &HasDisposeBagKey) as? DisposeBag {
                return bag
            }
            let bag = DisposeBag()
            objc_setAssociatedObject(self, &HasDisposeBagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return bag
        }
    }
}

extension NSObject: HasDisposeBag {
}
