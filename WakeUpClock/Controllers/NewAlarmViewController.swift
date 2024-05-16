//
//  NewAlarmViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit
import CoreData

class NewAlarmViewController: UIViewController {
    private let daysArray: [String] = [" M", " T", " W", " Th", " F", " St", " S"]
    private var hourArray: [Int] = []
    private var minuteArray: [Int] = []
    private var soundsArray: [String] = ["TestSound1", "TestSound2", "TestSound3"]
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0
    private var selectedSoundIndex: Int = 0
    private var selectedDays: [Bool] = [false, false, false, false, false, false, false]
        
    // MARK: - 스크롤 뷰
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.backgroundColor = UIColor(named: "grassEffectColor")?.withAlphaComponent(0.3)
        return scrollView
    }()
    
    // MARK: - 시간 관련 뷰
    private var timeSelectView: UIView = {
        let view = UIView()
        //view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderColor = UIColor(named: "textColor")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - 시간, 분 정렬
    private var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        return stackView
    }()
    
    private var hourView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    // MARK: - :
    private var colonLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.textAlignment = .center
        return label
    }()
    private var minuteView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - 시간 선택
    private var hourPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    // MARK: - 분 선택
    private var minutePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    // MARK: - Select Time
    private var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select time"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 날짜 관련 뷰
    private var daysView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Days
    private var daysTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Days"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 날짜를 담을 스택 뷰
    private var daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - 알람 이름 관련 뷰
    private var alarmNameView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Name
    private var alarmTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 알람 이름을 입력할 텍스트필드
    private var alarmNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(named: "backgroundColor")
        textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.borderWidth = 1
        return textField
    }()
    
    // MARK: - 옵션 설정 관련 뷰
    private var preferencesView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - 프레퍼런스 타이틀
    private var preferencesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preferences"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 진동 관련 스택뷰
    private var preferenceVibrationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - 진동 레이블
    private var preferenceVibrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Vibration"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    // MARK: - 진동 유무 설정할 스위치
    private var preferenceVibrationSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        return uiSwitch
    }()
    
    // MARK: - 스누즈 관련 스택뷰
    private var preferenceSnoozeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - 스누즈 레이블
    private var preferenceSnoozeLabel: UILabel = {
        let label = UILabel()
        label.text = "Snooze"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    // MARK: - 스누즈 버튼
    private var preferenceSnoozeSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        return uiSwitch
    }()
    
    // MARK: - 사운드 관련 스택뷰
    private var preferenceSoundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - 사운드 레이블
    private var preferenceSoundLabel: UILabel = {
        let label = UILabel()
        label.text = "Sound"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    // MARK: - 사운드 선택 피커뷰
    private var preferenceSoundPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    // MARK: - 버튼을 담을 스택 뷰
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - 취소 버튼
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 등록 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(named: "secondaryColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.borderColor = UIColor(named: "secondaryColor")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        hourPickerView.dataSource = self
        hourPickerView.delegate = self
        minutePickerView.dataSource = self
        minutePickerView.delegate = self
        preferenceSoundPickerView.dataSource = self
        preferenceSoundPickerView.delegate = self
        
        for i in 0...23 {
            hourArray.append(i)
        }
        for i in 0...59 {
            minuteArray.append(i)
        }
        
        setupAddView()
        setupAutoLayout()
    }
    
    // MARK: - 코어데이터 입력하기
    private func insertMyAlarmEntities() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "MyAlarm", in: context) else { return }
        let alarm = NSManagedObject(entity: entity, insertInto: context)
        alarm.setValue(UUID(), forKey: "id")
        //alarm.setValue(time, forKey: "time")
//        alarm.setValue(repeatDays, forKey: "repeatDays")
        alarm.setValue(alarmNameTextField.text, forKey: "title")
        alarm.setValue(preferenceVibrationSwitch.isOn, forKey: "isVibration")
        alarm.setValue(preferenceSnoozeSwitch.isOn, forKey: "isSnooze")
        alarm.setValue(soundsArray[selectedSoundIndex], forKey: "sound")
        alarm.setValue(true, forKey: "isEnabled")
        try? context.save()
        
    }
    
    // MARK: - 취소 버튼 선택
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        print("취소버튼 선택")
        //dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 완료 버튼 선택
    @objc private func doneButtonTapped(_ sender: UIButton) {
        print("**********완료버튼 선택**********")
        print("선택 시간: \(selectedHour), 선택 분: \(selectedMinute)")
        print("선택 요일: \(selectedDays)")
        print("알람 이름: \(alarmNameTextField.text)")
        print("진동유무: \(preferenceVibrationSwitch.isOn), 스누즈유무: \(preferenceSnoozeSwitch.isOn), 선택Sound: \(soundsArray[selectedSoundIndex])")
        
    }
    
    // MARK: - 날짜 버튼 선택
    @objc private func dayButtonTapped(_ sender: UIButton) {
        guard let day = sender.currentTitle else { return }
        
        //날짜 저장을 위한 리턴
        if let index = daysArray.firstIndex(of: day) {
            if selectedDays[index] == false {
                selectedDays[index] = true
            } else if selectedDays[index] == true {
                selectedDays[index] = false
            }
        }
        
        //날짜 선택에 따른 체크박스 버튼 이미지 변경
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage(named: "checkbox"), for: .normal)
        } else {
            sender.tag = 0
            sender.setImage(UIImage(named: "box"), for: .normal)
        }
    }
    
    // MARK: - addView
    private func setupAddView() {
        view.addSubview(scrollView)
        
        //Select Time
        scrollView.addSubview(timeSelectView)
        timeSelectView.addSubview(timeTitleLabel)
        timeSelectView.addSubview(timeStackView)
        timeStackView.addArrangedSubview(hourView)
        hourView.addSubview(hourPickerView)
        timeStackView.addArrangedSubview(colonLabel)
        timeStackView.addArrangedSubview(minuteView)
        minuteView.addSubview(minutePickerView)
        
        //Days
        scrollView.addSubview(daysView)
        daysView.addSubview(daysTitleLabel)
        daysView.addSubview(daysStackView)
        for day in daysArray {
            let button = UIButton()
            button.setImage(UIImage(named: "box"), for: .normal)
            button.setTitle(day, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(UIColor(named: "textColor"), for: .normal)
            button.tag = 0
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            daysStackView.addArrangedSubview(button)
        }
        
        //Name
        scrollView.addSubview(alarmNameView)
        alarmNameView.addSubview(alarmTitleLabel)
        alarmNameView.addSubview(alarmNameTextField)
        
        //preferences
        scrollView.addSubview(preferencesView)
        preferencesView.addSubview(preferencesTitleLabel)
        preferencesView.addSubview(preferenceVibrationStackView)
        preferenceVibrationStackView.addArrangedSubview(preferenceVibrationLabel)
        preferenceVibrationStackView.addArrangedSubview(preferenceVibrationSwitch)
        preferencesView.addSubview(preferenceSnoozeStackView)
        preferenceSnoozeStackView.addArrangedSubview(preferenceSnoozeLabel)
        preferenceSnoozeStackView.addArrangedSubview(preferenceSnoozeSwitch)
        preferencesView.addSubview(preferenceSoundStackView)
        preferenceSoundStackView.addArrangedSubview(preferenceSoundLabel)
        preferenceSoundStackView.addArrangedSubview(preferenceSoundPickerView)
        
        //button
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(doneButton)
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //Select Time
        timeSelectView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        timeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSelectView.snp.top).offset(10)
            make.leading.equalTo(timeSelectView.snp.leading).offset(10)
            make.trailing.equalTo(timeSelectView.snp.trailing).offset(-10)
        }
        timeStackView.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(timeSelectView.snp.leading).offset(100)
            make.trailing.equalTo(timeSelectView.snp.trailing).offset(-100)
        }
        
        hourView.snp.makeConstraints { make in
            make.width.equalTo(timeStackView.snp.width).multipliedBy(0.45)
            make.height.equalTo(100)
        }
        colonLabel.snp.makeConstraints { make in
            make.width.equalTo(timeStackView.snp.width).multipliedBy(0.1)
        }
        minuteView.snp.makeConstraints { make in
            make.width.equalTo(timeStackView.snp.width).multipliedBy(0.45)
            make.height.equalTo(100)
        }
        
        hourPickerView.snp.makeConstraints { make in
            make.centerX.equalTo(hourView.snp.centerX)
            make.centerY.equalTo(hourView.snp.centerY)
        }
        minutePickerView.snp.makeConstraints { make in
            make.centerX.equalTo(minuteView.snp.centerX)
            make.centerY.equalTo(minuteView.snp.centerY)
        }
        
        //days
        daysView.snp.makeConstraints { make in
            make.top.equalTo(timeSelectView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        daysTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(daysView.snp.top).offset(10)
            make.leading.equalTo(daysView.snp.leading).offset(10)
        }
        daysStackView.snp.makeConstraints { make in
            make.top.equalTo(daysTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(daysView.snp.leading).offset(5)
            make.trailing.equalTo(daysView.snp.trailing).offset(-5)
        }
        alarmNameView.snp.makeConstraints { make in
            make.top.equalTo(daysView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        alarmTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmNameView.snp.top).offset(10)
            make.leading.equalTo(alarmNameView.snp.leading).offset(10)
            make.trailing.equalTo(alarmNameView.snp.trailing).offset(-10)
        }
        alarmNameTextField.snp.makeConstraints { make in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(alarmNameView.snp.leading).offset(10)
            make.trailing.equalTo(alarmNameView.snp.trailing).offset(-10)
            make.bottom.equalTo(alarmNameView.snp.bottom).offset(-10)
        }
        
        //preference
        preferencesView.snp.makeConstraints { make in
            make.top.equalTo(alarmNameView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        preferencesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(preferencesView.snp.top).offset(10)
            make.leading.equalTo(preferencesView.snp.leading).offset(10)
            make.trailing.equalTo(preferencesView.snp.trailing).offset(-10)
        }
        preferenceVibrationStackView.snp.makeConstraints { make in
            make.top.equalTo(preferencesTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(preferencesView.snp.leading).offset(10)
            make.trailing.equalTo(preferencesView.snp.trailing).offset(-10)
        }
        preferenceSnoozeStackView.snp.makeConstraints { make in
            make.top.equalTo(preferenceVibrationStackView.snp.bottom).offset(20)
            make.leading.equalTo(preferencesView.snp.leading).offset(10)
            make.trailing.equalTo(preferencesView.snp.trailing).offset(-10)
        }
        preferenceSoundStackView.snp.makeConstraints { make in
            make.top.equalTo(preferenceSnoozeStackView.snp.bottom).offset(10)
            make.leading.equalTo(preferencesView.snp.leading).offset(10)
            make.trailing.equalTo(preferencesView.snp.trailing).offset(-10)
            //make.height.equalTo(preferenceSnoozeStackView.snp.height)
            make.bottom.equalTo(preferencesView.snp.bottom).offset(-10)
        }
        
        //button
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(preferencesView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
}


extension NewAlarmViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var cnt: Int = 0
        if pickerView == hourPickerView {
            cnt = hourArray.count
        } else if pickerView == minutePickerView {
            cnt = minuteArray.count
        } else if pickerView == preferenceSoundPickerView {
            cnt = soundsArray.count
        }
        return cnt
    }
}

extension NewAlarmViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var string = ""
        
        if pickerView == hourPickerView {
            string = "\(hourArray[row])"
        } else if pickerView == minutePickerView {
            string = "\(minuteArray[row])"
        } else if pickerView == preferenceSoundPickerView {
            string = "\(soundsArray[row])"
        }
        return string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPickerView {
            selectedHour = pickerView.selectedRow(inComponent: 0)
        } else if pickerView == minutePickerView {
            selectedMinute = pickerView.selectedRow(inComponent: 0)
        } else if pickerView == preferenceSoundPickerView {
            selectedSoundIndex = pickerView.selectedRow(inComponent: 0)
        }
    }
}
