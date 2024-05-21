//
//  ClockCell.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/21/24.
//

import UIKit
import SnapKit

class ClockCell: UICollectionViewCell {
    
    static let identifier = "ClockCell"
    
    let timeZoneLabel: UILabel = UIFactory.makeLabel(text: "Seoul", color: UIColor(named: "textColor") ?? .black, fontSize: 20, weight: .medium)
    let timeOffsetLabel: UILabel = UIFactory.makeLabel(text: "+0시간", color: UIColor(named: "textColor") ?? .black, fontSize: 14, weight: .regular)
    let timeLabel: UILabel = UIFactory.makeLabel(text: "13:55", color: UIColor(named: "textColor") ?? .black, fontSize: 40, weight: .semibold)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.glassEffect
        layer.cornerRadius = 20
    }
    
    private func setupConstraints() {
        [timeZoneLabel, timeOffsetLabel, timeLabel].forEach {
            contentView.addSubview($0)
        }
        
        timeZoneLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        timeOffsetLabel.snp.makeConstraints {
            $0.top.equalTo(timeZoneLabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(timeOffsetLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    
    
}
