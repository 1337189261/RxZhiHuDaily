//
//  StoryDetailView.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import HYSwift
import WebKit

final class StoryDetailViewController: UIViewController, Routable {
    
    let viewmodel = StoryDetailViewModel()
    let webView: WKWebView = {
        let script = WKUserScript(source: "document.getElementsByClassName('img-place-holder')[0].style.display = 'none'", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        config.userContentController.addUserScript(script)
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        bind()
    }
    
    func bind() {
        viewmodel.storyDetail.subscribe(onNext: {[weak self] (detail) in
            guard let detail = detail, let strongSelf = self, detail.css?.isEmpty == false, let body = detail.body else {
                return
            }
            // 坑: 这里 api 返回的 css 链接是 http 链接, 需要改为 https, 但由于 css 基本不变, 暂时使用固定的
            let htmlString = "<html><head><meta name='viewport' content='initial-scale=1.0,user-scalable=no' /><link type='text/css' rel='stylesheet' href = 'https://news-at.zhihu.com/css/news_qa.auto.css?v=97942' ></link></head><body>\(body)</body></html>"
            strongSelf.webView.loadHTMLString(htmlString, baseURL: nil)
        }).disposed(by: bag)
    }
    
    convenience init(params: [String : Any]) {
        self.init()
        if let storyID = params["StoryID"] as? Int {
            viewmodel.fetchStory(no: String(storyID))
        }
    }
}
