//
//  StoryDetail.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import Foundation
import HandyJSON

struct StoryDetail: HandyJSON {
    var body, imageHue, imageSource: String?
    var sectionThumbnail: String?
    var title: String?
    var url: String?
    var image: String?
    var sectionID: Int?
    var shareURL: String?
    var js: [String]?
    var sectionName, gaPrefix: String?
    var images: [String]?
    var type, id: Int?
    var css: [String]?
}
