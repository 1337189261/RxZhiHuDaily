//
//  NavigationBarView.swift
//  RxZhihuDaily
//
//  Created by chenhaoyu.1999 on 2020/8/30.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {
    
    static let kHeight:CGFloat = 104
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.height.width.equalTo(60)
        }
        return label
    }()
    
    lazy var seperator: UIView = {
        let seperator = UIView()
        addSubview(seperator)
        seperator.snp.makeConstraints { (make) in
            make.leading.equalTo(self.dateLabel.snp.trailing)
            make.centerY.equalTo(self.dateLabel)
            make.height.equalTo(36)
            make.width.equalTo(1)
        }
        return seperator
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 24)
        label.textColor = UIColor.from(hex: "1a1a1a")
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(self.dateLabel.snp.trailing).offset(14)
            make.centerY.equalTo(self.dateLabel)
        }
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        dateLabel.attributedText = dateAttributedText
        seperator.backgroundColor = UIColor.from(hex: "D3D3D3")
        greetingLabel.text = self.greeting
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dayString: String {
        String(Calendar.current.component(.day, from: Date()))
    }
    
    var monthString: String = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_cn")
        formatter.dateFormat = "MMMM"
        return formatter.string(from: .init())
    }()
    
    var dateAttributedText: NSAttributedString {
        let dateString = dayString + "\n" + monthString
        let attributedString = NSMutableAttributedString(string: dateString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = -5
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.from(hex: "444444")!, NSAttributedString.Key.paragraphStyle: paragraphStyle.copy()], range: NSRange(location: 0, length: dateString.count))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont(name: "PingFangSC-Semibold", size: 20)!], range: NSRange(location: 0, length: dayString.count))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: 12)!], range: NSRange(location: dayString.count + 1, length: monthString.count))
        return attributedString.copy() as! NSAttributedString
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: .init())
        if (hour >= 0 && hour < 6) || hour >= 23 {
            return "早点休息"
        } else if hour <= 9 {
            return "早上好!"
        } else if hour <= 18 {
            return "知乎日报"
        } else {
            return "晚上好!"
        }
    }
}
