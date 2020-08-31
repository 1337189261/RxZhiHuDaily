//
//  Store.swift
//  RxZhihuDaily
//
//  Created by chenhaoyu.1999 on 2020/8/29.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import Foundation
import WCDBSwift

let dataBase = Store.shared.dataBase

struct Store {
    
    static let shared = Store()
    
    private init() {
        try? dataBase.create(table: String(describing: Story.self), of: Story.self)
    }
    
    let dataBase = Database(withPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/HY/HYDB.db")
    
}

extension TableEncodable where Self: TableDecodable {
    
    static var tableName: String {
        String(describing: Self.self)
    }
    
    func save() {
        try? dataBase.insert(objects: [self], intoTable: Self.tableName)
    }
    
    func delete(where condition: Condition?) {
        try? dataBase.delete(fromTable: Self.tableName, where: condition)
    }
    
    static func query(condition: Condition? = nil, orderedBy orderList:[OrderBy]? = nil, offset: Offset? = nil) -> [Self] {
        (try? dataBase.getObjects(fromTable: Self.tableName, where: condition, orderBy: orderList, offset: offset)) ?? [Self]()
    }
    
    static func dropTable() {
        try? dataBase.drop(table: Self.tableName)
    }
    
}
