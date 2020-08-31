//
//  DateUtil.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/7/2.
//  Copyright © 2020 陈浩宇. All rights reserved.
//
import Foundation

fileprivate let formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    return dateFormatter
}()

extension Date {
    var apiDateString: String {
        formatter.string(from: self)
    }
    
    var numberFormat: Int? {
        Int(apiDateString)
    }
    
    var headerString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: self)
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    static func from(dateString: String) -> Date {
        formatter.date(from: dateString) ??  Date()
    }
}
