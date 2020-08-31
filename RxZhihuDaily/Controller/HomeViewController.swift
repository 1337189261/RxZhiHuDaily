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
import Alamofire

final class HomeViewController: UIViewController, Routable {
    
    let viewmodel = HomeViewModel()
    let navigationBarView = NavigationBarView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let headerViewContainer = UIView()
    let topStoriesHeaderView = TopStoriesHeaderView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let headerHeight:CGFloat = 375

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(NavigationBarView.kHeight)
        }
        
        view.insertSubview(tableView, belowSubview: navigationBarView)
        tableView.register(StoryTableViewCell.self)
        tableView.register(StorySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "StorySectionHeaderView")
        tableView.rowHeight(104)
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (maker) in
            maker.leading.bottom.trailing.equalToSuperview()
            maker.top.equalTo(navigationBarView.snp.bottom)
        }
        
        headerViewContainer.frame = CGRect(x: 0, y: 0, width: 0, height: headerHeight)
        headerViewContainer.addSubview(topStoriesHeaderView)
        topStoriesHeaderView.minimumInteritemSpacing = 0
        topStoriesHeaderView.commonSetup()
        let layout = topStoriesHeaderView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: kScreenWidth, height: headerHeight)
        topStoriesHeaderView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: headerHeight)
        tableView.tableHeaderView = headerViewContainer
        
        bind()
        
        viewmodel.fetchLatest()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.viewmodel.loadFromDisk(date: Date.yesterday)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.viewmodel.loadFromDisk(date: Date.yesterday.dayBefore)
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewmodel.loadNetwork(date: Date.yesterday)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewmodel.loadNetwork(date: Date.yesterday.dayBefore)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setNeedsStatusBarAppearanceUpdate()
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
        
        viewmodel.topStories.bind(to: topStoriesHeaderView.rx.items(cellIdentifier: String(describing: HeaderImageViewCell.self), cellType: HeaderImageViewCell.self)) { row, topStory, cell in
            cell.titleLabel.text = topStory.title
            cell.subTitleLabel.text = topStory.hint
            let imgUrl = URL(string: topStory.image ?? "")
            cell.imgView.sd_setImage(with: imgUrl) {[weak self] (image, error, cacheType, url) in
                guard let strongSelf = self else {
                    return
                }
                cell.imgView.image = image?.cropTo(widthHeightRatio: kScreenWidth / strongSelf.headerHeight)
            }
            var imageHue = topStory.image_hue
            imageHue?.removeFirst(2)
            if let color = UIColor.from(hex: imageHue ?? "") {
                cell.gradientLayer.colors = [color.withAlphaComponent(0.01).cgColor, color.cgColor ]
            } else {
                cell.gradientLayer.colors = [UIColor.clear]
            }
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Story.self)
        .map{ $0.id }
        .subscribe(onNext: {id in
//            guard let id = id else {
//                return
//            }
//            Router.shared.open(url: URL(string: "detail://"), params:["StoryID": id])
        }).disposed(by: bag)
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        topStoriesHeaderView.rx.setDelegate(self).disposed(by: bag)
        
    }
    
    convenience init(params: [String : Any]) {
        self.init(nibName: nil, bundle: nil)
    }
    
}

extension HomeViewController: UITableViewDelegate, UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let offsetY = scrollView.contentOffset.y
            // 取消 section header 吸顶效果
            if offsetY < NavigationBarView.kHeight && offsetY >= 0 {
                scrollView.contentInset = UIEdgeInsets(top: -offsetY, left: 0, bottom: 0, right: 0)
            } else if offsetY >= NavigationBarView.kHeight {
                scrollView.contentInset = UIEdgeInsets(top: -NavigationBarView.kHeight, left: 0, bottom: 0, right: 0)
            }
            // 弹性 header 效果
            if offsetY < 0 {
                let height = abs(offsetY) + headerHeight
                let frame = CGRect(x: 0, y: -abs(offsetY), width: kScreenWidth, height: height)
                topStoriesHeaderView.frame = frame
                topStoriesHeaderView.itemSize = CGSize(width: kScreenWidth, height: floor(height))
            }
        } else if scrollView == topStoriesHeaderView {
            let offsetX = scrollView.contentOffset.x
            if offsetX == CGFloat(self.viewmodel.topStories.value.count - 1) * kScreenWidth {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StorySectionHeaderView") as! StorySectionHeaderView
        view.set(date: Date.from(dateString: viewmodel.sections.value[section].dateString))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 36
    }
}

