//
//  TimerTableViewCell.swift
//  WakeUpClock
//
//  Created by IMHYEONJEONG on 5/13/24.
//

import UIKit
import SnapKit

class TimerTableViewCell: UITableViewCell {
    
    static let identifier = "TimerTableViewCell"
    
    let timerLabel = UILabel()
    let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:   reuseIdentifier)
        contentView.backgroundColor = .frame
        contentView.addSubview(timerLabel)
        contentView.addSubview(nameLabel)
        
        timerLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(24)
            $0.top.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-24)
            $0.centerY.equalTo(timerLabel.snp.centerY)
//            $0.width.equalTo(147)
        }
        
        timerLabel.textColor = .text
        timerLabel.text = "00:00:00"
        timerLabel.font = .systemFont(ofSize: 18, weight: .regular)
        nameLabel.textColor = .text
        nameLabel.text = "일어나시계"
        nameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


