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
import WCDBSwift
import Reachability

class HomeViewModel: NSObject {
    
    let sections = BehaviorRelay(value: [StorySection]())
    let loadLock = NSLock()
    let topStories = BehaviorRelay<[Story]>(value: [])
    var dates = [Date]()
    
    func fetchLatest() {
        API.provider.request(.lastest).mapJson()
            .subscribe(onNext: { json in
                if let stories = [Story].deserialize(from: json["stories"].arrayObject), let dateString = json["date"].string {
                    let storiesWithDate = stories.map {(story: Story?) -> Story? in
                        var story = story
                        story?.dateNumber = Int(dateString)
                        return story
                    }
                    let lastestStorySection = StorySection(dateString: dateString, stories: storiesWithDate.compactMap {$0})
                    Date.from(dateString: dateString).saveLatest()
                    self.sections.accept([lastestStorySection])
                    if let topStories = [Story].deserialize(from: json["top_stories"].arrayObject), let first = topStories.first {
                        self.topStories.accept(topStories.compactMap {$0} + [first!])
                    }
                }
            }).disposed(by: bag)
    }
    
    func loadStories(date: Date) {
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
//            loadNetwork(date: date)
            loadFromDisk(date: date)
        } else {
            loadFromDisk(date: date)
        }
    }
    
    func loadNetwork(date: Date) {
        loadLock.lock()
        API.provider.request(.before(dateString: date.apiDateString)).retry(3).mapJson()
            .subscribe(onNext: { (json) in
                self.loadLock.unlock()
                if let stories = [Story].deserialize(from: json["stories"].arrayObject) {
                    stories.forEach { $0?.save() }
                    let storySection = StorySection(dateString: date.headerString, stories: stories.compactMap {$0})
                    self.sections.accept(self.sections.value + [storySection])
                }
            }, onError: { error in
                self.loadLock.unlock()
                print(error)
            }).disposed(by: bag)
    }
    
    func loadFromDisk(date: Date, completion: ((Bool) -> Void)? = nil) {
        loadLock.lock()
        DispatchQueue.global().async {
            defer { self.loadLock.unlock() }
            let stories = Story.query(condition: Story.Properties.dateNumber == date.numberFormat ?? 0, orderedBy: nil, offset: nil)
            guard stories.count != 0 else {
                completion?(false)
                return
            }
            let storySection = StorySection(dateString: date.headerString, stories: stories)
            self.sections.accept(self.sections.value + [storySection])
            completion?(true)
        }
    }
    
}

extension MoyaProvider {
    
    func request(_ token: Target) -> Observable<Response> {
        rx.request(token).asObservable()
    }
}

extension ObservableType where Self.Element == Moya.Response {
    func mapJson() -> Observable<JSON> {
        mapJSON().map { JSON($0) }
    }
}

