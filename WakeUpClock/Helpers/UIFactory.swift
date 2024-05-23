//
//  UIFactory.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/20/24.
//

import UIKit

class UIFactory {
    
    static func makeStackView(alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 20) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
    
    static func makeLabel(text: String = "", color: UIColor = .white, fontSize: CGFloat = 32, weight: UIFont.Weight = .semibold, textAlignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textAlignment = textAlignment
        return label
    }
    
    static func makeButton(title: String = "", backgroundColor: UIColor = .clear, tintColor: UIColor, borderColor: CGColor = UIColor.mainText.cgColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(tintColor, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor
        return button
    }
    
    static func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    // MARK: - NewAlarmViewController 날짜 버튼
    static func makeDayButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        button.tag = 0
        button.contentHorizontalAlignment = .left
        return button
    }
    
    // MARK: - NewAlarmViewController 타이틀 Lable
    static func makeTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }
    
    // MARK: - NewAlarmViewController 피커뷰를 담을 뷰
    static func makeTimeView(backgroundColor: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }
}
