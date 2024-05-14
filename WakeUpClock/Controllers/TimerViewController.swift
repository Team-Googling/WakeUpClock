//
//  TimerViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit
import DurationPicker

class TimerViewController: UIViewController {

    let dumi: [String] = ["1", "2", "3", "4", "5"]
    
    private var timer = Timer()
    var remainTime = UILabel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let backgroundCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .glassEffect
        
        let shadowLayer = CALayer()
        shadowLayer.frame = CGRect(x: 0, y: 0, width: 330, height: 330)
        shadowLayer.shadowColor = UIColor(named: "frameColor")?.cgColor
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowRadius = 5
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 360, height: 360), cornerRadius: 180)
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.position = view.center
        view.layer.insertSublayer(shadowLayer, at: 0)
        
        return view
    }()
    let timerDurationPicker = DurationPicker()
    let startButton = UIButton()
    let cancelButton = UIButton()
    
    let saveTimerView = UIView()
    let nameLabel = UILabel()
    let nameInputTextField = UITextField()
    
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
        contentView.addSubview(backgroundCircleView)
        contentView.addSubview(timerDurationPicker)
        contentView.addSubview(remainTime)
        contentView.addSubview(cancelButton)
        contentView.addSubview(startButton)
        contentView.addSubview(saveTimerView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameInputTextField)
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
        
        backgroundCircleView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(40)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.width.height.equalTo(330)
        }
        
        timerDurationPicker.snp.makeConstraints {
            $0.centerX.equalTo(backgroundCircleView.snp.centerX)
            $0.centerY.equalTo(backgroundCircleView.snp.centerY)
        }
        
        remainTime.snp.makeConstraints {
            $0.centerX.equalTo(backgroundCircleView.snp.centerX)
            $0.centerY.equalTo(backgroundCircleView.snp.centerY)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(backgroundCircleView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(32)
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(backgroundCircleView.snp.bottom).offset(40)
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
        
        nameInputTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(saveTimerView.snp.leading).inset(12)
            $0.trailing.equalTo(saveTimerView.snp.trailing).inset(12)
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
        
        backgroundCircleView.backgroundColor = .glassEffect
//        backgroundCircleView.alpha = 0.5
        backgroundCircleView.layer.cornerRadius = 165
        backgroundCircleView.clipsToBounds = true
        
        timerDurationPicker.pickerMode = .hourMinuteSecond
        remainTime.isHidden = true
        remainTime.font = .systemFont(ofSize: 30, weight: .medium)
        remainTime.text = "00"
        remainTime.textColor = .white
        
        cancelButton.layer.cornerRadius = 24
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderColor = UIColor.mainInactiveText.cgColor
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.mainInactiveText, for: .normal)
        cancelButton.layer.borderWidth = 1
        
        startButton.layer.cornerRadius = 24
        startButton.backgroundColor = .clear
        startButton.layer.borderColor = UIColor.mainActive.cgColor
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.mainActive, for: .normal)
        startButton.layer.borderWidth = 1
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        // 타이머 이름 입력
        saveTimerView.backgroundColor = .mainActive
        saveTimerView.alpha = 0.05
        saveTimerView.layer.cornerRadius = 8
        nameLabel.text = "Name"
        nameLabel.textColor = UIColor(named: "textColor")
        nameInputTextField.backgroundColor = .mainActive
        nameInputTextField.alpha = 0.1
        nameInputTextField.layer.cornerRadius = 5
        
        // 최근 타이머 목록
        recentlyUsedView.backgroundColor = .clear
        recentlyUsedLabel.textColor = UIColor(named: "textColor")
        recentlyUsedLabel.text = "Recently Used"
        recentlyUsedLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        recentlyUsedTabelView.backgroundColor = .blue
        recentlyUsedTabelView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.identifier)
        
    }
    
    @objc func didTapStartButton() {
        print(#function)
        let setTime = Int(timerDurationPicker.duration) // 설정 된 시간
        setTimer(with: setTime)
    }
    // 타이머 시작
    func setTimer(with countDownSeconds: Int) {
        print("countDownSeconds: \(countDownSeconds)")
        timerDurationPicker.isHidden = true
        remainTime.isHidden = false
        
        let startTime = Date() // 현재시간
        timer.invalidate() // 기존에 실행된 타이머 중지
        remainTime.text = String(countDownSeconds) // 설정된 시간으로 시작
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime)) // 경과된 시간
            let remainSeconds = Int(countDownSeconds) - elapsedTimeSeconds // 남은 시간
            guard remainSeconds >= 0 else {
                timer.invalidate() // 0초 되면 타이머 중지
                self?.timerDurationPicker.isHidden = false
                self?.remainTime.isHidden = true
                
                return
            }
            print("remainSeconds: \(remainSeconds)")
            self?.remainTime.text = "\(remainSeconds)"
            
        })
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
