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
    
    let clockBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clockBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    let timeZoneLabel: UILabel = UIFactory.makeLabel(text: "Seoul", color: UIColor(named: "textColor") ?? .black, fontSize: 20, weight: .medium)
    let timeOffsetLabel: UILabel = UIFactory.makeLabel(text: "+0시간", color: UIColor(named: "textColor") ?? .black, fontSize: 14, weight: .regular)
    let timeLabel: UILabel = UIFactory.makeLabel(text: "13:55", color: UIColor(named: "textColor") ?? .black, fontSize: 40, weight: .semibold)
    let timePeriodLabel: UILabel = UIFactory.makeLabel(text: "AM", color: UIColor(named: "textColor") ?? .black, fontSize: 14, weight: .regular)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // 이미지뷰를 셀의 백그라운드로 추가
        contentView.addSubview(clockBackgroundImageView)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        
        // 라벨들을 이미지뷰 위에 추가
        [timeZoneLabel, timeOffsetLabel, timePeriodLabel, timeLabel].forEach {
            clockBackgroundImageView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        // 이미지뷰의 제약 조건 설정
        clockBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 라벨들의 제약 조건 설정
        timeZoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        timeOffsetLabel.snp.makeConstraints { make in
            make.top.equalTo(timeZoneLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        
        timePeriodLabel.snp.makeConstraints { make in
            make.bottom.equalTo(timeLabel.snp.bottom).inset(8)
            make.trailing.equalTo(timeLabel.snp.leading).inset(-4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeOffsetLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(18)
        }
    }
}
