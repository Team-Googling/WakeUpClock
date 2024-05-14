//
//  StopwatchViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit

class StopwatchViewController: UIViewController {
    
    // MARK: - 프로퍼티
    private let mainStopwatch: Stopwatch = Stopwatch()
    private let lapStopwatch: Stopwatch = Stopwatch()
    private var isPlay: Bool = false
    private var lapTableViewData: [String] = []
    
    // MARK: - 컴포넌트
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private let minutesLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minutesSeparatorLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondsLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondsSeparatorLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let milliSecondsLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lapButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lap", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()
    
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor(named: "mainActiveColor"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "mainActiveColor")?.cgColor
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        setupButtons()
    }
    
    private func configureUI() {
        lapButton.isEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StopwatchCell.self, forCellReuseIdentifier: StopwatchCell.identifier)
        tableView.backgroundColor = UIColor(named: "backGroudColor")
    }
    
    // MARK: - 레이아웃 설정
    private func setupConstraints() {
        
        [stackView, lapButton, startButton, tableView].forEach {
            view.addSubview($0)
        }
        
        let minuteView = createNumberContainerView()
        minuteView.addSubview(minutesLabel)
        
        let secondView = createNumberContainerView()
        secondView.addSubview(secondsLabel)
        
        let msView = createNumberContainerView()
        msView.addSubview(milliSecondsLabel)
        
        [minuteView, minutesSeparatorLabel, secondView, secondsSeparatorLabel, msView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(216)
        }
        
        minuteView.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(56)
        }
        
        minutesLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        secondView.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(56)
        }
        
        secondsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        msView.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(56)
        }
        
        milliSecondsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        lapButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(46)
            $0.top.equalTo(stackView.snp.bottom).offset(66)
            $0.leading.equalToSuperview().inset(32)
        }
        
        startButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(46)
            $0.centerY.equalTo(lapButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(32)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(40)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createNumberContainerView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(named: "glassEffectColor")
        containerView.layer.cornerRadius = 8
        return containerView
    }
    
    // MARK: - 버튼 이벤트 처리
    private func setupButtons() {
        lapButton.addTarget(self, action: #selector(lapButtonPressed), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    @objc private func lapButtonPressed() {
        
        // 시간이 멈춰있을 때 -> 버튼 누르면 reset 되어야 함
        if !isPlay {
            resetMainTimer()
            changeButton(lapButton, title: "Lap", titleColor: UIColor.gray)
            lapButton.layer.borderColor = UIColor.gray.cgColor
            lapButton.isEnabled = false
        }
        
        // 시간이 가고 있을 때 -> 테이블 뷰 셀의 데이터를 추가
        else {
            let timerLabelText = "\(minutesLabel.text ?? "00"):\(secondsLabel.text ?? "00"):\(milliSecondsLabel.text ?? "00")"
            lapTableViewData.append(timerLabelText)
        }
        
        tableView.reloadData()
    }
    
    @objc private func startButtonPressed() {
        lapButton.isEnabled = true
        
        lapButton.setTitle("Lap", for: .normal)
        lapButton.setTitleColor(UIColor(named: "mainTextColor"), for: .normal)
        lapButton.layer.borderColor = UIColor(named: "mainTextColor")?.cgColor
        
        // 시간이 멈춰있을 때 -> 버튼 누르면 시간이 흘러야 함
        if !isPlay {
            unowned let weakSelf = self
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.01, target: weakSelf, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            
            isPlay = true
            changeButton(startButton, title: "Stop", titleColor: UIColor.red)
            startButton.layer.borderColor = UIColor.red.cgColor
        }
        
        // 시간이 흐를 때 -> 버튼 누르면 멈춰야 함
        else {
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            
            isPlay = false
            
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(UIColor(named: "mainActiveColor"), for: .normal)
            startButton.layer.borderColor = UIColor(named: "mainActiveColor")?.cgColor
 
            lapButton.setTitle("Reset", for: .normal)
            lapButton.setTitleColor(UIColor(named: "mainTextColor"), for: .normal)
            lapButton.layer.borderColor = UIColor(named: "mainTextColor")?.cgColor
        }
        
    }
}

// MARK: - Action Functions
extension StopwatchViewController {
    
    func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: .normal)
    } // --> 수정해야함!
    
    func resetTimer(_ stopwatch: Stopwatch, labels: [UILabel]) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        for label in labels {
            label.text = "00"
        }
    }
    
    func resetMainTimer() {
        resetTimer(mainStopwatch, labels: [minutesLabel, secondsLabel, milliSecondsLabel])
        lapTableViewData.removeAll()
        tableView.reloadData()
    }
    
    @objc func updateMainTimer() {
        updateTimer(mainStopwatch, labels: [minutesLabel, secondsLabel, milliSecondsLabel])
    }
    
    func updateTimer(_ stopwatch: Stopwatch, labels: [UILabel]) {
        stopwatch.counter += 0.01
        
        let minutes = Int(stopwatch.counter / 60)
        let seconds = Int(stopwatch.counter.truncatingRemainder(dividingBy: 60))
        let milliseconds = Int((stopwatch.counter * 100).truncatingRemainder(dividingBy: 100))
        
        labels[0].text = String(format: "%02d", minutes) // 분
        labels[1].text = String(format: "%02d", seconds) // 초
        labels[2].text = String(format: "%02d", milliseconds) // 밀리초
    }
}

fileprivate extension Selector {
    static let updateMainTimer = #selector(StopwatchViewController.updateMainTimer)
}

// MARK: - TableView Extenseion
extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchCell.identifier, for: indexPath) as? StopwatchCell else { return UITableViewCell() }
        cell.lapLabel.text = "lap"
        cell.recordLabel.text = "record"
        cell.diffLabel.text = "diff"
        return cell
    }
}
//#Preview{
//    StopwatchViewController()
//}
