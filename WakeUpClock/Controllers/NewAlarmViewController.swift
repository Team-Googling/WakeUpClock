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
    private let daysArray: [String] = [" Monday", " Tuesday", " Wednesday", " Thursday", " Friday", " Saturday", " Sunday"]
    private var hourArray: [Int] = Array(0...23)
    private var minuteArray: [Int] = Array(0...59)
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0
    private var selectedDays: [Bool] = [false, false, false, false, false, false, false]

    // MARK: - 시간 선택
    private var hourPickerView = UIPickerView()
    // MARK: - 분 선택
    private var minutePickerView = UIPickerView()
    
    // MARK: - Select Time
    private var timeTitleLabel = UIFactory.makeTitleLabel(title: "Select time")
    // MARK: - Days
    private var daysTitleLabel = UIFactory.makeTitleLabel(title: "Days")
    // MARK: - 알람 이름
    private var alarmTitleLabel = UIFactory.makeTitleLabel(title: "Name")
    
    // MARK: - 날짜 버튼
    private lazy var mondayButton: UIButton = UIFactory.makeDayButton(title: daysArray[0])
    private lazy var tuesdayButton: UIButton = UIFactory.makeDayButton(title: daysArray[1])
    private lazy var wednesdayButton: UIButton = UIFactory.makeDayButton(title: daysArray[2])
    private lazy var thursdayButton: UIButton = UIFactory.makeDayButton(title: daysArray[3])
    private lazy var fridayButton: UIButton = UIFactory.makeDayButton(title: daysArray[4])
    private lazy var saturdayButton: UIButton = UIFactory.makeDayButton(title: daysArray[5])
    private lazy var sundayButton: UIButton = UIFactory.makeDayButton(title: daysArray[6])
                
    // MARK: - 시간 피커뷰를 담을 뷰
    private let hourView = UIFactory.makeTimeView(backgroundColor: UIColor(named: "glassEffectColor") ?? .clear)
    // MARK: - 분 피커뷰를 담을 뷰
    private let minuteView = UIFactory.makeTimeView(backgroundColor: UIColor(named: "textColor") ?? .clear)
    
    // MARK: - :
    private var colonLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.font = .systemFont(ofSize: 57)
        label.textAlignment = .center
        return label
    }()
        
    // MARK: - 알람 이름을 입력할 텍스트필드
    private var alarmNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "alarm"
        return textField
    }()
    
    // MARK: - 가로선
    private var horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .mainText
        return view
    }()
    
    // MARK: - 취소 버튼
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        button.layer.borderColor = UIColor(named: "textColor")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - 등록 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(named: "mainActiveColor"), for: .normal)
        button.layer.borderColor = UIColor(named: "mainActiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
        setupAddView()
        setupConstraints()
        setupButtons()
        setupKeyboard()
    }
    
    // MARK: - 키보드 이벤트
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            // 여기서 원하는 뷰의 위치를 조정합니다.
            self.view.frame.origin.y = -keyboardHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 뷰 위치를 원래대로 돌립니다.
        self.view.frame.origin.y = 0
    }
    
    // MARK: - 버튼 이벤트 처리
    private func setupButtons() {
        [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton].forEach {
            $0.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            if traitCollection.userInterfaceStyle == .dark {
                $0.setImage(UIImage(named: "dark-box"), for: .normal)
            } else {
                $0.setImage(UIImage(named: "box"), for: .normal)
            }
        }
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - 설정
    private func setupConfigure() {
        view.backgroundColor = UIColor(named: "backGroudColor")
        
        hourPickerView.dataSource = self
        hourPickerView.delegate = self
        minutePickerView.dataSource = self
        minutePickerView.delegate = self
        alarmNameTextField.delegate = self
        
        if self.traitCollection.userInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
        
    // MARK: - String -> Date 변환
    private func convertStringToDate(_ hour: Int, _ minute: Int) -> Date? {
        let dateString: String = "\(hour):\(minute)"  // 넣을 데이터
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "HH:mm"
        myFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let stirngDate = myFormatter.date(from: dateString)
        return stirngDate
    }
    
    // MARK: - 코어데이터 입력하기
    private func insertMyAlarmEntities() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "MyAlarm", in: context) else { return }
        let alarm = NSManagedObject(entity: entity, insertInto: context)
        alarm.setValue(UUID(), forKey: "id")
        alarm.setValue(convertStringToDate(selectedHour, selectedMinute), forKey: "time")
        alarm.setValue(selectedDays, forKey: "repeatDays")
        let alarmName = alarmNameTextField.text ?? "알람"
        alarm.setValue(alarmName, forKey: "title")
        alarm.setValue(true, forKey: "isEnabled")
        try? context.save()
    }
    
    // MARK: - 취소 버튼 선택
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 완료 버튼 선택
    @objc private func doneButtonTapped(_ sender: UIButton) {
        //날짜 선택 유무 확인
        if selectedDays.filter({ $0 == false }).count == 7 {
            let alertController = UIAlertController(title: "날짜 선택", message: "날짜를 선택하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
   
        let dateString: String = "\(selectedHour):\(selectedMinute)"
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "HH:mm"
        myFormatter.timeZone =  NSTimeZone(name: "UTC") as TimeZone?
        
        insertMyAlarmEntities() //코어데이터 입력
        
        NotificationCenter.default.post(name: NSNotification.Name("ModalDidDismiss"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 날짜 버튼 선택
    @objc private func dayButtonTapped(_ sender: UIButton) {
        guard let day = sender.currentTitle else { return }
        
        //선택 날짜 확인
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
            if traitCollection.userInterfaceStyle == .dark {
                sender.setImage(UIImage(named: "dark-checkbox"), for: .normal)
            } else {
                sender.setImage(UIImage(named: "checkbox"), for: .normal)
            }
        } else {
            sender.tag = 0
            if traitCollection.userInterfaceStyle == .dark {
                sender.setImage(UIImage(named: "dark-box"), for: .normal)
            } else {
                sender.setImage(UIImage(named: "box"), for: .normal)
            }
        }
    }
       
    // MARK: - addView
    private func setupAddView() {
        //Select Time
        [timeTitleLabel, hourView, colonLabel, minuteView].forEach {
            view.addSubview($0)
        }
        hourView.addSubview(hourPickerView)
        minuteView.addSubview(minutePickerView)

        //Days
        [daysTitleLabel, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton].forEach {
            view.addSubview($0)
        }
        
        //Name
        [alarmTitleLabel, alarmNameTextField, horizontalLine].forEach {
            view.addSubview($0)
        }
        
        //button
        [cancelButton, doneButton].forEach {
            view.addSubview($0)
        }
    }
    
    // MARK: - 레이아웃 설정
    private func setupConstraints() {
        timeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
        hourView.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(63)
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        colonLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(24)
            make.leading.equalTo(hourView.snp.trailing)
            make.width.equalTo(24)
            make.height.equalTo(80)
        }
        minuteView.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(24)
            make.leading.equalTo(colonLabel.snp.trailing)
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        hourPickerView.snp.makeConstraints { make in
            make.centerX.equalTo(hourView.snp.centerX)
            make.centerY.equalTo(hourView.snp.centerY)
        }
        minutePickerView.snp.makeConstraints { make in
            make.centerX.equalTo(minuteView.snp.centerX)
            make.centerY.equalTo(minuteView.snp.centerY)
        }
        
        //날짜
        daysTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(hourView.snp.bottom).offset(60)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
        }
        mondayButton.snp.makeConstraints { make in
            make.top.equalTo(daysTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
            make.width.equalTo(140)
            make.height.equalTo(36)
        }
        tuesdayButton.snp.makeConstraints { make in
            make.top.equalTo(mondayButton.snp.bottom)
            make.leading.equalTo(mondayButton.snp.leading)
            make.width.equalTo(mondayButton.snp.width)
            make.height.equalTo(mondayButton.snp.height)
        }
        wednesdayButton.snp.makeConstraints { make in
            make.top.equalTo(tuesdayButton.snp.bottom)
            make.leading.equalTo(mondayButton.snp.leading)
            make.width.equalTo(mondayButton.snp.width)
            make.height.equalTo(mondayButton.snp.height)
        }
        thursdayButton.snp.makeConstraints { make in
            make.top.equalTo(wednesdayButton.snp.bottom)
            make.leading.equalTo(mondayButton.snp.leading)
            make.width.equalTo(mondayButton.snp.width)
            make.height.equalTo(mondayButton.snp.height)
        }
        fridayButton.snp.makeConstraints { make in
            make.top.equalTo(mondayButton.snp.top)
            make.leading.equalTo(mondayButton.snp.trailing).offset(60)
            make.width.equalTo(mondayButton.snp.width)
            make.height.equalTo(mondayButton.snp.height)
        }
        saturdayButton.snp.makeConstraints { make in
            make.top.equalTo(fridayButton.snp.bottom)
            make.leading.equalTo(fridayButton.snp.leading)
            make.width.equalTo(mondayButton.snp.width)
            make.height.equalTo(mondayButton.snp.height)
        }
        sundayButton.snp.makeConstraints { make in
            make.top.equalTo(saturdayButton.snp.bottom)
            make.leading.equalTo(fridayButton.snp.leading)
            make.width.equalTo(mondayButton.snp.width)
            make.height.equalTo(mondayButton.snp.height)
        }
        
        //name
        alarmTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(thursdayButton.snp.bottom).offset(60)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
        }
        alarmNameTextField.snp.makeConstraints { make in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(alarmTitleLabel.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(36)
        }
        horizontalLine.snp.makeConstraints { make in
            make.top.equalTo(alarmNameTextField.snp.bottom)
            make.leading.equalTo(alarmTitleLabel.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(1)
        }
        
        //button
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(alarmNameTextField.snp.bottom).offset(160)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(40)
            make.width.equalTo(120)
            make.height.equalTo(46)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(alarmNameTextField.snp.bottom).offset(160)
            make.leading.equalTo(cancelButton.snp.trailing).offset(70)
            make.width.equalTo(cancelButton.snp.width)
            make.height.equalTo(cancelButton.snp.height)
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
        }
        return cnt
    }
}

extension NewAlarmViewController: UIPickerViewDelegate {
    // MARK: - 선택 시간 확인
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPickerView {
            selectedHour = pickerView.selectedRow(inComponent: 0)
        } else if pickerView == minutePickerView {
            selectedMinute = pickerView.selectedRow(inComponent: 0)
        }
    }
    
    // MARK: - 피커뷰 텍스트 크기 조절
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        //룰렛의 기본 배경색을 초기화
        pickerView.subviews.forEach { subview in
            subview.backgroundColor = .clear
        }
        
        if pickerView == hourPickerView {
            label.text = "\(hourArray[row])"
            label.font = UIFont.systemFont(ofSize: 52)
            label.textAlignment = .center
            if traitCollection.userInterfaceStyle == .dark {
                label.textColor = .white
            } else {
                label.textColor = .black
            }
        } else if pickerView == minutePickerView {
            label.text = "\(minuteArray[row])"
            label.font = UIFont.systemFont(ofSize: 52)
            label.textAlignment = .center
            if traitCollection.userInterfaceStyle == .dark {
                label.textColor = .black
            } else {
                label.textColor = .white
            }
        }
        return label
    }
        
    // MARK: - 피커뷰 룰렛 높이 조절
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 52
    }
}

extension NewAlarmViewController: UITextFieldDelegate {
    // MARK: - return시 키보드 닫기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
