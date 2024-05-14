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
    
    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hoursSeparatorLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let lapButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lap", for: .normal)
        button.setTitleColor(UIColor(named: "mainInactiveTextColor"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "mainInactiveTextColor")?.cgColor
        return button
    }()
    
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor(named: "mainActiveColor"), for: .normal)
        button.backgroundColor = .gray
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
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
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
        
        let hourView = createNumberContainerView()
        hourView.addSubview(hoursLabel)
        
        let minuteView = createNumberContainerView()
        minuteView.addSubview(minutesLabel)
        
        let secondView = createNumberContainerView()
        secondView.addSubview(secondsLabel)
        
        [hourView, hoursSeparatorLabel, minuteView, minutesSeparatorLabel, secondView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(216)
        }
        
        hourView.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(56)
        }
        
        hoursLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
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
    }
    
    @objc private func lapButtonPressed() {
       
        // 시간이 멈춰있을 때 -> 버튼 누르면 lap으로 바뀌어야 함
        if !isPlay {
            resetMainTimer()
            changeButton(lapButton, title: "Lap", titleColor: UIColor(named: "mainInactiveTextColor") ?? UIColor(red: 174/255, green: 174/255, blue: 183/255, alpha: 1.0))
            lapButton.isEnabled = false
        }
        
        // 시간이 가고 있을 때 -> 테이블 뷰 셀의 데이터를 추가
        else {
            let timerLabelText = "\(hoursLabel.text ?? "00"):\(minutesLabel.text ?? "00"):\(secondsLabel.text ?? "00")"
            lapTableViewData.append(timerLabelText)
        }
        
        tableView.reloadData()
    }
}
// MARK: - Action Functions
extension StopwatchViewController {
    func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: .normal)
    }
    
    func resetTimer(_ stopwatch: Stopwatch, labels: [UILabel]) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        for label in labels {
            label.text = "00"
        }
    }
    
    func resetMainTimer() {
        resetTimer(mainStopwatch, labels: [hoursLabel, minutesLabel, secondsLabel])
        lapTableViewData.removeAll()
        tableView.reloadData()
    }
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
