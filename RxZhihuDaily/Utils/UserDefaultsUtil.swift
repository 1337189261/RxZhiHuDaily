//
//  UserDefaultsUtil.swift
//  RxZhihuDaily
//
//  Created by chenhaoyu.1999 on 2020/8/30.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let lastestDateKey = "lastestDateKey"
    
    static func lastestDate() -> Date? {
        UserDefaults.standard.object(forKey: Self.lastestDateKey) as? Date
    }
    
}

extension Date {
    func saveLatest() {
        UserDefaults.standard.set(self, forKey: UserDefaults.lastestDateKey)
    }
}
