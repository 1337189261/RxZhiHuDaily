//
//  Story.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import Foundation
import HandyJSON
import RxDataSources
import WCDBSwift

public struct Story: HandyJSON, TableCodable {
    
    var image_hue: String?
    var title: String?
    var url: String?
    var hint: String?
    // 普通 Story
    var images: [String]?
    // TopStory
    var image: String?
    var type, id: Int?
    
    var dateNumber: Int?
    
    public init() { }
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = Story
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case image_hue, title, url, images, image, type, id, dateNumber
        static var columnConstraintBindings = [id: ColumnConstraintBinding(isPrimary: true, onConflict: .replace)]
    }
    
}

struct StorySection: SectionModelType {
    init(original: StorySection, items: [Story]) {
        self = original
        self.items = items
    }
    
    init(dateString: String, stories: [Item]) {
        self.dateString = dateString
        self.items = stories
    }
    
    typealias Item = Story
    let dateString: String
    var items: [Item]
}
