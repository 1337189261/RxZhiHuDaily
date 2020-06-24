//
//  HomeViewModel.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import HYSwift
import Moya
import SwiftyJSON

class HomeViewModel:NSObject {
    
    let stories = BehaviorRelay<[Story]>(value: [])
    
    func fetchLatest() {
        API.provider.request(.lastest).mapJSON()
            .map({ (json) -> JSON in
                JSON(json)
            })
            .subscribe(onNext: { json in
                if let stories = [Story].deserialize(from: json["stories"].arrayObject) {
                    self.stories.accept(stories.compactMap {$0})
                }
            }).disposed(by: bag)
    }
}

extension MoyaProvider {
    
    func request(_ token: Target) -> Observable<Response> {
        return rx.request(token).asObservable()
    }
}

extension ObservableType where Self.Element == Moya.Response {
    public func mapJson() -> Observable<JSON> {
        return mapJSON().map { (json) -> JSON in
            JSON(json)
        }
    }
}

