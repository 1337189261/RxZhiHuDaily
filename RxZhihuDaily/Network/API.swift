//
//  API.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import HYSwift

enum API {
    case lastest
    case detail(no: String)
    
    static let provider = MoyaProvider<API>(stubClosure: MoyaProvider<API>.immediatelyStub)
}

extension API: TargetType {
    var sampleData: Data {
        switch self {
        case .lastest:
            return readJSON(fileName: "Latest")
        case .detail(let _):
            return readJSON(fileName: "StoryDetail")
        }
    }
    
    var task: Task {
        .requestPlain
    }
    
    var path: String {
        switch self {
        case .lastest:
            return "/latest"
        case .detail(let no):
            return "/\(no)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var baseURL: URL {
        URL(string: "https://news-at.zhihu.com/api/3/stories")!
    }
}