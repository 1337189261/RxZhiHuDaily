//
//  ViewController.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import HYSwift
import SDWebImage
import RxDataSources

final class HomeViewController: UIViewController, Routable {
    
    let scrollView = UIScrollView()
    let topStoriesImageView = UIImageView()
    let viewmodel = HomeViewModel()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.register(StoryTableViewCell.self)
        tableView.rowHeight(104)
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        bind()
        viewmodel.fetchLatest()
    }
    
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<StorySection>(configureCell:  { (dataSource, tableView, indexPath, story) in
            let cell: StoryTableViewCell = tableView.dequeReusableCell()
            cell.titleLabel.text = story.title
            cell.subTitleLabel.text = story.hint
            cell.imgView.sd_setImage(with: URL(string: story.images?[0] ?? ""))
            return cell
        })
        
        viewmodel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.modelSelected(Story.self)
        .map{ $0.id }
        .subscribe(onNext: {id in
            guard let id = id else {
                return
            }
            Router.shared.open(url: URL(string: "detail://"), params:["StoryID": id])
        }).disposed(by: bag)
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        
    }
    
    convenience init(params: [String : Any]) {
        self.init(nibName: nil, bundle: nil)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.1))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
    }
}
