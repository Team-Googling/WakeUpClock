//
//  TimerViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {

    let dumi: [String] = ["1", "2", "3", "4", "5"]
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let backgroundView = UIView()
    let timerDatePicker = UIDatePicker()
    let startButton = UIButton()
    let cancelButton = UIButton()
    
    let saveTimerView = UIView()
    let nameLabel = UILabel()
    let nameInputTextButton = UIButton()
    let saveTimerButton = UIButton()
    
    let recentlyUsedView = UIView()
    let recentlyUsedLabel = UILabel()
    let recentlyUsedTabelView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.tintColor = UIColor.blue
        recentlyUsedTabelView.dataSource = self
        recentlyUsedTabelView.delegate = self
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgroundView)
        contentView.addSubview(timerDatePicker)
        contentView.addSubview(cancelButton)
        contentView.addSubview(startButton)
        contentView.addSubview(saveTimerView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameInputTextButton)
        contentView.addSubview(saveTimerButton)
        contentView.addSubview(recentlyUsedView)
        contentView.addSubview(recentlyUsedLabel)
        contentView.addSubview(recentlyUsedLabel)
        contentView.addSubview(recentlyUsedTabelView)
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(40)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
//            $0.centerX.equalTo(contentView.snp.centerX)
            $0.width.height.equalTo(330)
        }
        
        timerDatePicker.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView.snp.centerX)
            $0.centerY.equalTo(backgroundView.snp.centerY)
//            $0.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(32)
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(40)
            $0.trailing.equalToSuperview().offset(-32)
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
        
        saveTimerView.snp.makeConstraints {
            $0.top.equalTo(cancelButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(88)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(saveTimerView.snp.top).offset(12)
            $0.leading.equalTo(saveTimerView.snp.leading).offset(24)
        }
        
        nameInputTextButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(saveTimerView.snp.leading).offset(28)
            $0.bottom.equalTo(saveTimerView.snp.bottom).inset(12)
        }
        
        saveTimerButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(nameInputTextButton.snp.trailing).offset(-5)
            $0.trailing.equalTo(saveTimerView.snp.trailing).offset(-28)
            $0.bottom.equalTo(saveTimerView.snp.bottom).inset(12)
        }
        
        recentlyUsedView.snp.makeConstraints {
            $0.top.equalTo(saveTimerView.snp.bottom).offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        recentlyUsedLabel.snp.makeConstraints {
            $0.top.equalTo(recentlyUsedView.snp.top).offset(12)
            $0.leading.equalTo(recentlyUsedView.snp.leading).offset(12)
            $0.trailing.equalTo(recentlyUsedView.snp.trailing).offset(-12)
        }
        
        recentlyUsedTabelView.snp.makeConstraints {
            $0.top.equalTo(recentlyUsedLabel.snp.bottom).offset(20)
            $0.leading.equalTo(recentlyUsedView.snp.leading).offset(12)
            $0.bottom.equalTo(recentlyUsedView.snp.bottom).offset(-12)
            $0.trailing.equalTo(recentlyUsedView.snp.trailing).offset(-12)
            
        }
    }
    
    func configureUI() {
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        backgroundView.backgroundColor = .white
        backgroundView.alpha = 0.5
        backgroundView.layer.cornerRadius = 165
        backgroundView.clipsToBounds = true
        
        timerDatePicker.datePickerMode = .countDownTimer
        
        cancelButton.layer.cornerRadius = 24
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderColor = UIColor.gray.cgColor
        cancelButton.setTitle("Cancle", for: .normal)
        cancelButton.setTitleColor(.gray, for: .normal)
        cancelButton.layer.borderWidth = 1
        
        startButton.layer.cornerRadius = 24
        startButton.backgroundColor = .clear
        startButton.layer.borderColor = UIColor.orange.cgColor
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.orange, for: .normal)
        startButton.layer.borderWidth = 1
        
        saveTimerView.backgroundColor = .orange
        saveTimerView.alpha = 0.05
        saveTimerView.layer.cornerRadius = 8
        nameLabel.text = "Name"
        nameLabel.textColor = .white
        nameInputTextButton.backgroundColor = .white
        
        saveTimerButton.backgroundColor = .clear
        saveTimerButton.setTitle("Save", for: .normal)
        saveTimerButton.setTitleColor(.white, for: .normal)
        
        recentlyUsedView.backgroundColor = .red
        
        recentlyUsedLabel.textColor = .white
        recentlyUsedLabel.text = "Recently Used"
        recentlyUsedLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        recentlyUsedTabelView.backgroundColor = .blue
        recentlyUsedTabelView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.identifier)
        
        
    }
    

}

extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        36
    }
}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dumi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recentlyUsedTabelView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier, for: indexPath) as? TimerTableViewCell else { return TimerTableViewCell() }
        cell.timerLabel.text = "00:10:00"
        cell.nameLabel.text = "10분만 걷자"
        return cell
    }
    
    
}

//#Preview {
//    TimerViewController()  // 해당 컨트롤러
//  // 화면 업데이트: command+option+p
//}
