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

struct Story: HandyJSON {
    var imageHue, title: String?
    var url: String?
    var hint, gaPrefix: String?
    var images: [String]?
    var type, id: Int?
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
