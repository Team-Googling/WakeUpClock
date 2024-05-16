//
//  TimerViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit
import DurationPicker

enum TimerState {
    case started
    case pause
    case resumed
    case canceled
    case finished
}

class TimerViewController: UIViewController {

    // MARK: - Properties
    private var timer = Timer()
    private var remainTime = UILabel()
//    private var isTimerRunning: Bool = false
    private var timerState: TimerState = .finished
    
    private var timerLists: [String] = []
    private var setTime: Int = 0
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backgroundCircleView: UIView = {
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
    private let timerDurationPicker = DurationPicker()
    private let startButton = UIButton()
    private let cancelButton = UIButton()
    private let saveTimerView = UIView()
    private let nameLabel = UILabel()
    private let nameInputTextField = UITextField()
    private let recentlyUsedView = UIView()
    private let recentlyUsedLabel = UILabel()
    private let recentlyUsedTabelView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recentlyUsedTabelView.dataSource = self
        recentlyUsedTabelView.delegate = self
        setupConstraints()
        configureUI()
        setupButtons()
    }
    
    // MARK: - Setup
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
        remainTime.font = .systemFont(ofSize: 70, weight: .medium)
        remainTime.text = "00"
        remainTime.textColor = .text
        
        cancelButton.layer.cornerRadius = 24
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderColor = UIColor.mainInactiveText.cgColor
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.mainInactiveText, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.2
        
        startButton.layer.cornerRadius = 24
        startButton.backgroundColor = .clear
        startButton.layer.borderColor = UIColor.mainActive.cgColor
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.mainActive, for: .normal)
        startButton.layer.borderWidth = 1
        
        
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
    
    // MARK: 버튼 이벤트 처리
    private func setupButtons() {
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    @objc func didTapStartButton() {
        print(#function)

        switch timerState {
        case .started, .resumed :
            // 시작을 누르면 버튼을 pause 로 바꿔야함
            timer.invalidate()
            timerState = .pause
            updateTimerState()
        case .pause:
            // 일시정지를 누르면 resume 으로 버튼 변경, 시간 멈춤
            print("재실행")
            setTimer(with: setTime)
        case .canceled, .finished:
            self.setTime = Int(timerDurationPicker.duration) // 설정 된 시간
            timerLists.append(String(setTime))
            print("timerLists : \(timerLists)")
            setTimer(with: setTime)
        }
    }
    
    @objc func didTapCancelButton() {
        print(#function)
//        self.isTimerRunning = false
        timer.invalidate()
        timerState = .canceled
        updateTimerState()
        
    }
    
    // MARK: - Action Functions
    func setTimer(with countDownSeconds: Int) {
        print("countDownSeconds: \(countDownSeconds)")
//        isTimerRunning = true
        timerState = .started
        updateTimerState()
        
        let startTime = Date()
        timer.invalidate() // 기존에 실행된 타이머 중지
        remainTime.text = self.convertSecondsToTime(timeInSeconds: countDownSeconds)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime)) // 경과된 시간
            let remainSeconds = Int(countDownSeconds) - elapsedTimeSeconds
            guard remainSeconds >= 0 else {
                timer.invalidate() // 0초 되면 타이머 중지
                self?.timerState = .finished
                self?.updateTimerState()
                
                return
            }
//            print("remainSeconds: \(remainSeconds)")
            self?.setTime = remainSeconds
            self?.remainTime.text = self?.convertSecondsToTime(timeInSeconds: remainSeconds)
        })
    }
    
    // 시:분:초 형식으로 변환
    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds - hours * 3600) / 60
        let seconds = timeInSeconds %  60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    private func updateTimerState() {
        switch timerState {
        case .started:
            timerDurationPicker.isHidden = true
            remainTime.isHidden = false
            cancelButton.isEnabled = true
            cancelButton.alpha = 1
            startButton.layer.borderColor = UIColor.green.cgColor
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(.green, for: .normal)
        case .pause:
            // 타이머 일시정지 상태에 대한 UI 업데이트
            cancelButton.alpha = 1
            startButton.layer.borderColor = UIColor.mainActive.cgColor
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(.mainActive, for: .normal)
            
        case .resumed:
            // 타이머 재개 상태에 대한 UI 업데이트
            startButton.layer.borderColor = UIColor.green.cgColor
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(.green, for: .normal)
        case .canceled:
            // 타이머 취소 상태에 대한 UI 업데이트
            timerDurationPicker.isHidden = false
            remainTime.isHidden = true
            cancelButton.isEnabled = true
            cancelButton.alpha = 0.2
            startButton.layer.borderColor = UIColor.mainActive.cgColor
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(.mainActive, for: .normal)
            
        case .finished:
            // 타이머 완료 상태에 대한 UI 업데이트
            timerDurationPicker.isHidden = false
            remainTime.isHidden = true
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.2
            startButton.layer.borderColor = UIColor.mainActive.cgColor
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(.mainActive, for: .normal)
        }
    }

}

// MARK: - TableView Extenseion
extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        36
    }
}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return timerLists.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recentlyUsedTabelView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier, for: indexPath) as? TimerTableViewCell else { return TimerTableViewCell() }
        
//        cell.timerLabel.text = timerLists[indexPath.row]
        cell.nameLabel.text = "일어나야지"
        cell.timerLabel.text = "03:00"
        
        return cell
    }
    
    
}

//#Preview {
//    TimerViewController()  // 해당 컨트롤러
//  // 화면 업데이트: command+option+p
//}
