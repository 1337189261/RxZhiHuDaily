//
//  StoryTableViewCell.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit
import HYSwift

class StoryTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel.label(size: 17,weight: .semibold, hex: "1A1A1A")
    let subTitleLabel = UILabel.label(size: 13, hex: "999999")
    let imgView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(20)
            maker.leading.equalToSuperview().offset(16)
            maker.width.lessThanOrEqualTo(255)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(4)
            maker.leading.equalTo(titleLabel)
        }
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-16)
            maker.width.height.equalTo(72)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
