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

class HomeViewModel: NSObject {
    
    let sections = BehaviorRelay(value: [StorySection]())
    let isLoading = BehaviorRelay(value: false)
    let dateToLoad = BehaviorRelay(value: Date())
    let headerPicWidth = BehaviorRelay(value: 100)
    
    
    func fetchLatest() {
        API.provider.request(.lastest).mapJson()
            .subscribe(onNext: { json in
                if let stories = [Story].deserialize(from: json["stories"].arrayObject) {
                    let lastestStorySection = StorySection(dateString: Date().headerString, stories: stories.compactMap {$0})
                    self.sections.accept([lastestStorySection])
                }
            }).disposed(by: bag)
    }
    
    func loadMore() {
        guard isLoading.value == false else {
            return
        }
        isLoading.accept(true)
        API.provider.request(.before(dateString: dateToLoad.value.apiDateString)).retry(3).mapJson()
            .subscribe(onNext: { (json) in
                self.isLoading.accept(false)
                self.dateToLoad.accept(self.dateToLoad.value.dayBefore)
                if let stories = [Story].deserialize(from: json["stories"].arrayObject) {
                    let storySection = StorySection(dateString: self.dateToLoad.value.headerString, stories: stories.compactMap {$0})
                    self.sections.accept(self.sections.value + [storySection])
                }
            }, onError: { error in
                print(error)
            }).disposed(by: bag)
    }
    
    func prefetchStories() {
        
    }
    
    func updateStories() {
        
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

