//
//  StoryDetailModel.swift
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

class StoryDetailViewModel:NSObject {
    let storyDetail = BehaviorRelay<StoryDetail?>(value: nil)
    
    func fetchStory(no: String) {
        API.provider.request(.detail(no: no)).mapJson()
        .subscribe(onNext: { json in
            if let storyDetail = StoryDetail.deserialize(from: json.dictionaryObject) {
                self.storyDetail.accept(storyDetail)
            }
        }).disposed(by: bag)
    }
}


