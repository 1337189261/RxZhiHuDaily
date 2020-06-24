//
//  Story.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import Foundation
import HandyJSON

struct Story: HandyJSON {
    var imageHue, title: String?
    var url: String?
    var hint, gaPrefix: String?
    var images: [String]?
    var type, id: Int?
}
