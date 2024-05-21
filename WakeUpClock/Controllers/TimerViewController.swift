//
//  TimerViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit
import DurationPicker
import CoreData

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
    private var timerState: TimerState = .finished
    private var timerLists: [(time: Int, name: String?)] = []
    private var setTime: Int = 0
    var persistentContainer: NSPersistentContainer? {
       (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
   }
    
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
    private let nameView = UIView()
    private let nameLabel = UILabel()
    private let nameInputTextField = UITextField()
    private let recentlyUsedLabel = UILabel()
    private let recentlyUsedTabelView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recentlyUsedTabelView.dataSource = self
        recentlyUsedTabelView.delegate = self
        nameInputTextField.delegate = self
        setupConstraints()
        configureUI()
        setupButtons()
        setUpKeyboard()
        fetchTimers()
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
        contentView.addSubview(nameView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameInputTextField)
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
        
        nameView.snp.makeConstraints {
            $0.top.equalTo(cancelButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(88)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.top).offset(12)
            $0.leading.equalTo(nameView.snp.leading).offset(24)
        }
        
        nameInputTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(nameView.snp.leading).inset(12)
            $0.trailing.equalTo(nameView.snp.trailing).inset(12)
            $0.bottom.equalTo(nameView.snp.bottom).inset(12)
        }
        
        recentlyUsedLabel.snp.makeConstraints {
            $0.top.equalTo(nameInputTextField.snp.bottom).offset(50)
            $0.leading.equalTo(contentView.snp.leading).offset(12)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }
        
        recentlyUsedTabelView.snp.makeConstraints {
            $0.top.equalTo(recentlyUsedLabel.snp.bottom).offset(20)
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(10)
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
        nameView.backgroundColor = .mainActive
        nameView.alpha = 0.05
        nameView.layer.cornerRadius = 8
        nameLabel.text = "Name"
        nameLabel.textColor = UIColor(named: "textColor")
        nameInputTextField.backgroundColor = UIColor.mainActive.withAlphaComponent(0.1)
        nameInputTextField.layer.cornerRadius = 5
        nameInputTextField.textColor = UIColor.text.withAlphaComponent(1)
        
        // 최근 타이머 목록
        recentlyUsedLabel.textColor = UIColor(named: "textColor")
        recentlyUsedLabel.text = "Recently Used"
        recentlyUsedLabel.font = .systemFont(ofSize: 20, weight: .medium)
        recentlyUsedLabel.isHidden = true
        
        recentlyUsedTabelView.backgroundColor = .clear
        recentlyUsedTabelView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.identifier)
        recentlyUsedTabelView.isHidden = true
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
            addRecentTimer()
            print("timerLists : \(timerLists)")
            reloadTableView()
            setTimer(with: setTime)
        }
    }
    
    @objc func didTapCancelButton() {
        print(#function)
        timer.invalidate()
        timerState = .canceled
        updateTimerState()
        
    }
    
    
    // MARK: - Action Functions
    func setTimer(with countDownSeconds: Int) {
        print("countDownSeconds: \(countDownSeconds)")
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
    
    func reloadTableView() {
        if timerLists.count <= 0 {
            recentlyUsedLabel.isHidden = true
            recentlyUsedTabelView.isHidden = true
        }
        else {
            let rowHeight = 36
            recentlyUsedTabelView.isHidden = false
            recentlyUsedLabel.isHidden = false
            recentlyUsedTabelView.snp.remakeConstraints {
                $0.top.equalTo(recentlyUsedLabel.snp.bottom).offset(20)
                $0.leading.bottom.trailing.equalToSuperview()
                $0.height.equalTo(timerLists.count * rowHeight)
            }
            recentlyUsedTabelView.reloadData()
        }
    }
    
    private func updateTimerState() {
        switch timerState {
        case .started:
            timerDurationPicker.isHidden = true
            remainTime.isHidden = false
            cancelButton.isEnabled = true
            cancelButton.alpha = 1
            cancelButton.setTitleColor(.mainInactiveText, for: .normal)
            startButton.layer.borderColor = UIColor.systemGreen.cgColor
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(.systemGreen, for: .normal)
        case .pause:
            // 타이머 일시정지 상태에 대한 UI 업데이트
            cancelButton.alpha = 1
            cancelButton.setTitleColor(.mainInactiveText, for: .normal)
            startButton.layer.borderColor = UIColor.mainActive.cgColor
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(.mainActive, for: .normal)
            
        case .resumed:
            // 타이머 재개 상태에 대한 UI 업데이트
            cancelButton.alpha = 1
            cancelButton.setTitleColor(.mainInactiveText, for: .normal)
            startButton.layer.borderColor = UIColor.green.cgColor
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(.green, for: .normal)
            
        case .canceled, .finished:
            // 타이머 취소 상태에 대한 UI 업데이트
            timerDurationPicker.isHidden = false
            remainTime.isHidden = true
            cancelButton.isEnabled = true
            cancelButton.alpha = 0.2
            startButton.layer.borderColor = UIColor.mainActive.cgColor
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(.mainActive, for: .normal)
            
        }
    }
    
    // 키보드
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardUp() {
        let height = backgroundCircleView.frame.origin.y + backgroundCircleView.frame.size.height
        view.frame.origin.y = -(height)
    }
    
    @objc func keyboardDown() {
        view.frame.origin.y = 0
    }
    
    func addRecentTimer() {
//        let timerName = nameInputTextField.text
//        
//        if let timerName = timerName {
//            timerLists.insert((time: setTime, name: timerName), at: 0)
//        }
//        else {
//            timerLists.insert((time: setTime, name: nil), at: 0)
//        }
//        nameInputTextField.text = ""
        let timerName = nameInputTextField.text ?? ""
        let timerTime = setTime

        // Core Data에 저장
        saveTimer(name: timerName, time: timerTime)

        // 메모리 내 목록과 UI 업데이트
        timerLists.insert((time: timerTime, name: timerName), at: 0)
        
        nameInputTextField.text = ""
        reloadTableView()
    }

// MARK: - CORE DATA
    //core data 에 저장
    func saveTimer(name: String, time: Int) {
        guard let context = persistentContainer?.viewContext else { return }
        let myTimer = MyTimer(context: context)
        myTimer.name = name
        myTimer.time = Int32(time)

        do {
            try context.save()
            print("타이머가 성공적으로 저장되었습니다.")
        } catch {
            print("타이머 저장에 실패했습니다: \(error)")
        }
    }
    // core data 불러오기
    func fetchTimers() {
        guard let context = persistentContainer?.viewContext else { return }
        let fetchRequest = MyTimer.fetchRequest()

        do {
            let timers = try context.fetch(fetchRequest)
            timerLists = timers.map { timer in
                let time = Int(timer.time)
                let name = timer.name
                return (time: time, name: name)
            }
            timerLists.reverse()
            reloadTableView()
        } catch {
            print("타이머를 가져오는데 실패했습니다: \(error)")
        }
    }
    
    // core data 삭제
    func deleteTimer(timer: (time: Int, name: String?)) {
        guard let context = persistentContainer?.viewContext else { return }
        let fetchRequest = MyTimer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND time == %d", timer.name ?? "", timer.time)

        do {
            let fetchedTimers = try context.fetch(fetchRequest)
            for fetchedTimer in fetchedTimers {
                context.delete(fetchedTimer)
            }
            try context.save()
            print("타이머가 성공적으로 삭제되었습니다.")
        } catch {
            print("타이머 삭제에 실패했습니다: \(error)")
        }
    }

}

// MARK: - TextFieldDelegate
extension TimerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TableView Extenseion
extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        36
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time = timerLists[indexPath.row]
        setTimer(with: Int(time.time))
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let timerToDelete = timerLists[indexPath.row]
            deleteTimer(timer: timerToDelete)
            timerLists.remove(at: indexPath.row)
            recentlyUsedTabelView.deleteRows(at: [indexPath], with: .fade)
            reloadTableView()
            print("timerLists\(timerLists)")
        }
    }
}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recentlyUsedTabelView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier, for: indexPath) as? TimerTableViewCell else { return UITableViewCell() }
        let recentTimer = timerLists[indexPath.row]
        cell.timerLabel.text = self.convertSecondsToTime(timeInSeconds: Int(recentTimer.time))
        cell.nameLabel.text = recentTimer.name
        return cell
    }
}

//#Preview {
//    TimerViewController()  // 해당 컨트롤러
//  // 화면 업데이트: command+option+p
//}
