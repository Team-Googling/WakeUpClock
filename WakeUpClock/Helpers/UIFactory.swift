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
}
