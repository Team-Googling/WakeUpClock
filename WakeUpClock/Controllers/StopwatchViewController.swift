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
    private let lapStopwatch: Stopwatch = Stopwatch() // 랩타임 계산
    private var isPlay: Bool = false
    private var diffTime = "" // diff 타임 담아줄 변수
    private var lapTableViewData: [String] = []
    private var diffTableViewData: [String] = [] // 앞 기록과의 차이
    
    // MARK: - 컴포넌트
    private let stackView: UIStackView = UIFactory.makeStackView()
    private let minutesLabel: UILabel = UIFactory.makeLabel(text: "00")
    private let minutesSeparatorLabel: UILabel = UIFactory.makeLabel(text: ":")
    private let secondsLabel: UILabel = UIFactory.makeLabel(text: "00")
    private let secondsSeparatorLabel: UILabel = UIFactory.makeLabel(text: ":")
    private let milliSecondsLabel: UILabel = UIFactory.makeLabel(text: "00")
    private let lapResetButton: UIButton = UIFactory.makeButton(title: "Lap", backgroundColor: .clear, tintColor: UIColor.gray, borderColor: UIColor.gray.cgColor)
    private let startPauseButton: UIButton = UIFactory.makeButton(title: "Start", backgroundColor: .clear, tintColor: UIColor.mainActive, borderColor: UIColor.mainActive.cgColor)
    private let tableView: UITableView = UIFactory.makeTableView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        setupButtons()
        loadSavedTimes()
    }
    
    private func configureUI() {
        lapResetButton.isEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StopwatchCell.self, forCellReuseIdentifier: StopwatchCell.identifier)
        tableView.backgroundColor = UIColor(named: "backGroudColor")
    }
    
    // MARK: - 레이아웃 설정
    private func setupConstraints() {
        
        [stackView, lapResetButton, startPauseButton, tableView].forEach {
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
        
        lapResetButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(46)
            $0.top.equalTo(stackView.snp.bottom).offset(66)
            $0.leading.equalToSuperview().inset(32)
        }
        
        startPauseButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(46)
            $0.centerY.equalTo(lapResetButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(32)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(startPauseButton.snp.bottom).offset(40)
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
        lapResetButton.addTarget(self, action: #selector(lapResetButtonPressed), for: .touchUpInside)
        startPauseButton.addTarget(self, action: #selector(startPauseButtonPressed), for: .touchUpInside)
    }
    
    @objc private func lapResetButtonPressed() {
        
        // 시간이 멈춰있을 때 -> 버튼 누르면 reset 되어야 함
        if !isPlay {
            resetMainTimer()
            resetLapTimer()
            lapResetButton.isEnabled = false
            changeButton(lapResetButton, title: "Lap", titleColor: UIColor.gray)
            StopwatchCoreDataManager.shared.deleteAllTimes()
            StopwatchCoreDataManager.shared.deleteAllLaps()
        }
        
        // 시간이 가고 있을 때 -> 테이블 뷰 셀의 데이터를 추가
        // Lap 버튼을 눌렀을 때 lapStopwatch는 다시 reset이 되어야 함
        else {
            let timerLabelText = "\(minutesLabel.text ?? "00"):\(secondsLabel.text ?? "00"):\(milliSecondsLabel.text ?? "00")"
            lapTableViewData.append(timerLabelText)
            
            // diff 타임 배열에 추가해야함!
            diffTableViewData.append(diffTime)
            resetLapTimer()
            
            // 랩 저장하기
            let lapNumber = Int64(lapTableViewData.count)
            let recordTime = timerLabelText
            let diffTime = self.diffTime
            StopwatchCoreDataManager.shared.saveLap(lapNumber: lapNumber, recordTime: recordTime, diffTime: diffTime)
            
            // 랩 타이머 재시작
            unowned let weakSelf = self
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.01, target: weakSelf, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            // --> 타이머 생성 및 설정 0.01초마다 updateLapTimer 메서드를 호출
            RunLoop.current.add(lapStopwatch.timer, forMode: RunLoop.Mode.common)
        }
        
        tableView.reloadData()
    }
    
    @objc private func startPauseButtonPressed() {
        lapResetButton.isEnabled = true
        changeButton(lapResetButton, title: "Lap", titleColor: UIColor.mainText)
        
        // 시간이 멈춰있을 때 -> 버튼 누르면 시간이 흘러야 함
        if !isPlay {
            unowned let weakSelf = self
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.01, target: weakSelf, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.01, target: weakSelf, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopwatch.timer, forMode: RunLoop.Mode.common)
            RunLoop.current.add(lapStopwatch.timer, forMode: RunLoop.Mode.common)
            
            isPlay = true
            changeButton(startPauseButton, title: "Stop", titleColor: UIColor.red)
            
        }
        
        // 시간이 흐를 때 -> 버튼 누르면 멈춰야 함
        else {
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            
            isPlay = false
            changeButton(startPauseButton, title: "Start", titleColor: UIColor.mainActive)
            changeButton(lapResetButton, title: "Reset", titleColor: UIColor.mainText)
            
            // TODO: saveMainTimer()
            saveCurrentTime()
        }
    }
    // MARK: - CoreData
    func saveCurrentTime() {
        StopwatchCoreDataManager.shared.saveTime(minutes: minutesLabel.text ?? "00", seconds: secondsLabel.text ?? "00", milliSeconds: milliSecondsLabel.text ?? "00")
    }
    
    private func loadSavedTimes() {
        if let times = StopwatchCoreDataManager.shared.fetchAllTimes(), let lastTime = times.last {
            if let minutesString = lastTime.minutes, let secondsString = lastTime.seconds, let millisecondsString = lastTime.milliSeconds {
                let minutes = Int(minutesString) ?? 0
                let seconds = Int(secondsString) ?? 0
                let milliseconds = Int(millisecondsString) ?? 0
                
                // 타이머가 마지막으로 저장된 시간부터 시작하도록 설정
                let totalTimeInSeconds = Double(minutes * 60 + seconds) + Double(milliseconds) / 100.0
                mainStopwatch.counter = totalTimeInSeconds
                updateMainTimer() 
            } else {
                print("Error: Missing time components in the saved time data.")
                mainStopwatch.counter = 0.0
            }
        } else {
            mainStopwatch.counter = 0.0
        }
        
        // 랩타임 불러오기
        if let laps = StopwatchCoreDataManager.shared.fetchAllLaps() {
            lapTableViewData = laps.map { $0.recordTime ?? "00:00:00" }
            diffTableViewData = laps.map { $0.diffTime ?? "00:00:00" }
        }
        
        tableView.reloadData()
    }
}

// MARK: - Action Functions
extension StopwatchViewController {
    
    private func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: .normal)
        button.layer.borderColor = titleColor.cgColor
    }
    
    private func resetTimer(_ stopwatch: Stopwatch, labels: [UILabel]) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0
        for label in labels {
            label.text = "00"
        }
    }
    
    private func resetMainTimer() {
        resetTimer(mainStopwatch, labels: [minutesLabel, secondsLabel, milliSecondsLabel])
        lapTableViewData.removeAll()
        tableView.reloadData()
    }
    
    private func resetLapTimer() {
        lapStopwatch.timer.invalidate()
        lapStopwatch.counter = 0
    }
    
    @objc func updateMainTimer() {
        updateMainTimer(mainStopwatch, labels: [minutesLabel, secondsLabel, milliSecondsLabel])
    }
    
    @objc func updateLapTimer() {
        updateLapTimer(lapStopwatch)
    }
    
    private func updateMainTimer(_ stopwatch: Stopwatch, labels: [UILabel]) {
        stopwatch.counter += 0.01
        
        let minutes = Int(stopwatch.counter / 60)
        let seconds = Int(stopwatch.counter.truncatingRemainder(dividingBy: 60))
        let milliseconds = Int((stopwatch.counter * 100).truncatingRemainder(dividingBy: 100))
        
        labels[0].text = String(format: "%02d", minutes) // 분
        labels[1].text = String(format: "%02d", seconds) // 초
        labels[2].text = String(format: "%02d", milliseconds) // 밀리초
    } // --> 밀리초로 계산하고 분과 초로 변환하는 방식
    
    private func updateLapTimer(_ stopwatch: Stopwatch) {
        stopwatch.counter = stopwatch.counter + 0.01
        
        let minutes = Int(stopwatch.counter / 60)
        let seconds = Int(stopwatch.counter.truncatingRemainder(dividingBy: 60))
        let milliseconds = Int((stopwatch.counter * 100).truncatingRemainder(dividingBy: 100))
        
        diffTime = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds) +  ":" + String(format: "%02d", milliseconds)
    }
}
// MARK: - Selector
fileprivate extension Selector {
    static let updateMainTimer = #selector(StopwatchViewController.updateMainTimer)
    static let updateLapTimer = #selector(StopwatchViewController.updateLapTimer)
}

// MARK: - TableView DataSource
extension StopwatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchCell.identifier, for: indexPath) as? StopwatchCell else { return UITableViewCell() }
        
        // 최신 랩타임이 맨 위에 표시되도록 랩 번호 계산
        let lapCount = lapTableViewData.count - indexPath.row
        
        cell.lapLabel.text = "Lap \(lapCount)"

        // 실제 기록
        cell.recordLabel.text = "\(lapTableViewData[lapCount-1])"
        // 앞 기록과의 차이
        cell.diffLabel.text = "\(diffTableViewData[lapCount-1])"
        
        return cell
    }
}

// MARK: - TableView Delegate
extension StopwatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let copyMenuInteraction = UIEditMenuInteraction(delegate: self)
        tableView.addInteraction(copyMenuInteraction)
        
        let configuration = UIEditMenuConfiguration(identifier: nil, sourcePoint: tableView.accessibilityActivationPoint)
        copyMenuInteraction.presentEditMenu(with: configuration)
    }
}

// MARK: - UIEditMenuInteraction Delegate
extension StopwatchViewController: UIEditMenuInteractionDelegate {
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let copyAction = UIAction(title: "랩타임 기록 전체 복사하기") {_ in
            var copyBoard: [String] = []
            
            for indexNum in 0...self.lapTableViewData.count-1 {
                copyBoard.append("\(indexNum+1)     \(self.lapTableViewData[indexNum])     \(self.diffTableViewData[indexNum])\n")
            }
            UIPasteboard.general.strings = copyBoard
        }
        return UIMenu(children: [copyAction])
    }
}
