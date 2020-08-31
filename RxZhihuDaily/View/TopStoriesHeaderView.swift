//
//  TopStoriesHeaderView.swift
//  RxZhihuDaily
//
//  Created by chenhaoyu.1999 on 2020/8/29.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit
import HYSwift

final class TopStoriesHeaderView: UICollectionView {
    
    
    @objc let pageControl = UIPageControl()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(HeaderImageViewCell.self)
        isPagingEnabled = true
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.width.equalTo(100)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class HeaderImageViewCell: UICollectionViewCell {
    
    let imgView = UIImageView()
    let subTitleLabel = UILabel()
    let titleLabel = UILabel()
    let gradientView = UIView()
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgView)
        imgView.contentMode = .scaleAspectFill
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        subTitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        subTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "PingFangSC-SemiBold", size: 22)
        titleLabel.textColor = .white
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(subTitleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        imgView.addSubview(gradientView)
        gradientView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(187.5)
        }
        
        gradientView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 187.5)
        gradientLayer.locations = [NSNumber(0), NSNumber(1)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

