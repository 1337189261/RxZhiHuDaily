//
//  StorySectionHeaderView.swift
//  RxZhihuDaily
//
//  Created by chenhaoyu.1999 on 2020/8/30.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit

class StorySectionHeaderView: UITableViewHeaderFooterView {
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_cn")
        formatter.dateFormat = "MMMd日"
        return formatter
    }()
    
    let dateLabel = UILabel()
    let seperator = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        backgroundView = nil
        
        addSubview(dateLabel)
        dateLabel.textColor = UIColor.from(hex: "999999")
        dateLabel.font = UIFont(name: "PingFangSC-Medium", size: 14)
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(seperator)
        seperator.backgroundColor = UIColor.from(hex: "EBEBEB")
        seperator.snp.makeConstraints { (make) in
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func set(date: Date) {
        dateLabel.text = Self.formatter.string(from: date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
