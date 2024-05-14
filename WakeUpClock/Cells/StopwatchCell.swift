//
//  StopwatchCell.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/14/24.
//

import UIKit
import SnapKit

class StopwatchCell: UITableViewCell {

    static let identifier = "StopwatchCell"
    
    let lapLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    let recordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    let diffLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(lapLabel)
        contentView.addSubview(recordLabel)
        contentView.addSubview(diffLabel)
        
        lapLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16) 
        }
        
        recordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        diffLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
    }
    
    private func configureUI() {
        contentView.backgroundColor = UIColor(named: "backGroudColor")
        selectionStyle = .none
    }

}
