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
    private var selectedSoundIndex: Int = 0
    private var selectedDays: [Bool] = [false, false, false, false, false, false, false]
    private lazy var mondayButton: UIButton = makeButton(title: daysArray[0])
    private lazy var tuesdayButton: UIButton = makeButton(title: daysArray[1])
    private lazy var wednesdayButton: UIButton = makeButton(title: daysArray[2])
    private lazy var thursdayButton: UIButton = makeButton(title: daysArray[3])
    private lazy var fridayButton: UIButton = makeButton(title: daysArray[4])
    private lazy var saturdayButton: UIButton = makeButton(title: daysArray[5])
    private lazy var sundayButton: UIButton = makeButton(title: daysArray[6])
    
    // MARK: - 스크롤 뷰
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.backgroundColor = UIColor(named: "grassEffectColor")?.withAlphaComponent(0.3)
        return scrollView
    }()
    
    // MARK: - 시간 관련 뷰
    private var timeSelectView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "glassEffectColor")
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
//        view.layer.borderColor = UIColor(named: "frameColor")?.cgColor
//        view.layer.borderWidth = 1
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
//        view.layer.borderColor = UIColor(named: "textColor")?.cgColor
//        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - 시간 선택
    private var hourPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        //pickerView.backgroundColor = UIColor(named: "frameColor")
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
           
    // MARK: - 알람 이름 관련 뷰
    private var alarmNameView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "glassEffectColor")
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
        //textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.borderColor = UIColor(named: "textColor")?.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
                
    // MARK: - 버튼을 담을 스택 뷰
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        return stackView
    }()
    
    // MARK: - 취소 버튼
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.borderColor = UIColor(named: "textColor")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 등록 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(named: "mainActiveColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.borderColor = UIColor(named: "mainActiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backGroudColor")
        
        hourPickerView.dataSource = self
        hourPickerView.delegate = self
        minutePickerView.dataSource = self
        minutePickerView.delegate = self
        alarmNameTextField.delegate = self
        
        setupAddView()
        setupAutoLayout()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
            
    private func updateDayButtonImage(button: UIButton) {
        let imageName: String
        if button.tag == 0 {
            imageName = traitCollection.userInterfaceStyle == .dark ? "dark-box" : "box"
        } else {
            imageName = traitCollection.userInterfaceStyle == .dark ? "dark-checkbox" : "checkbox"
        }
        button.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // MARK: - String -> Date 변환
    func convertStringToDate(_ hour: Int, _ minute: Int) -> Date? {
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
        print("취소버튼 선택")
        dismiss(animated: true, completion: nil)
//        do {
//            // 코어 데이터에서 MyAlarm 엔티티의 모든 데이터를 가져오기
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            let request = NSFetchRequest<MyAlarm>(entityName: "MyAlarm")
//            let result = try context.fetch(request)
//            print("result: \(result)")
//            for date in result {
//                if let id = date.id {
//                    print(id)
//                }
//                if let time = date.time {
//                    print(time)
//                }
//                if let days = date.repeatDays {
//                    print(date.repeatDays)
//                }
//                print(date.title)
//                print(date.isEnabled)
//            }
//        } catch {
//            print("코어 데이터에서 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
//        }
    }
    
    // MARK: - 완료 버튼 선택
    @objc private func doneButtonTapped(_ sender: UIButton) {
        print("**********완료버튼 선택**********")
        print("선택 시간: \(selectedHour), 선택 분: \(selectedMinute)")
        print("선택 요일: \(selectedDays)")
        if selectedDays.filter({ $0 == false }).count == 7 {
            let alertController = UIAlertController(title: "날짜 선택", message: "날짜를 선택하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        print("알람 이름: \(alarmNameTextField.text ?? "")")
   
        let dateString: String = "\(selectedHour):\(selectedMinute)"
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "HH:mm"
        myFormatter.timeZone =  NSTimeZone(name: "UTC") as TimeZone?
        if let stirngDate = myFormatter.date(from: dateString) {
            print("선택 시간: \(stirngDate)")
        }
        
        insertMyAlarmEntities() //코어데이터 입력완료
        print("코어데이터 입력 완료")
        
        NotificationCenter.default.post(name: NSNotification.Name("ModalDidDismiss"), object: nil)
        dismiss(animated: true, completion: nil)
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
    
    private func makeButton(title: String) -> UIButton {
        let button = UIButton()
        if traitCollection.userInterfaceStyle == .dark {
            button.setImage(UIImage(named: "dark-box"), for: .normal)
        } else {
            button.setImage(UIImage(named: "box"), for: .normal)
        }
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        button.tag = 0
        button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        return button
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
        //scrollView.addSubview(daysView)
        timeSelectView.addSubview(daysView)
        daysView.addSubview(daysTitleLabel)
        //daysView.addSubview(daysStackView)
        daysView.addSubview(mondayButton)
        daysView.addSubview(tuesdayButton)
        daysView.addSubview(wednesdayButton)
        daysView.addSubview(thursdayButton)
        daysView.addSubview(fridayButton)
        daysView.addSubview(saturdayButton)
        daysView.addSubview(sundayButton)
        
//        for day in daysArray {
//            let button = UIButton()
//            if traitCollection.userInterfaceStyle == .dark {
//                button.setImage(UIImage(named: "dark-box"), for: .normal)
//            } else {
//                button.setImage(UIImage(named: "box"), for: .normal)
//            }
//            button.setTitle(day, for: .normal)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//            button.setTitleColor(UIColor(named: "textColor"), for: .normal)
//            button.tag = 0
//            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
//            daysStackView.addArrangedSubview(button)
//        }
        
        //Name
        scrollView.addSubview(alarmNameView)
        alarmNameView.addSubview(alarmTitleLabel)
        alarmNameView.addSubview(alarmNameTextField)
                
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
            make.height.equalToSuperview().multipliedBy(0.4)
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
            make.width.equalTo(timeStackView.snp.width).multipliedBy(0.5)
            make.height.equalTo(80)
        }
        colonLabel.snp.makeConstraints { make in
            make.width.equalTo(timeStackView.snp.width).multipliedBy(0.1)
        }
        minuteView.snp.makeConstraints { make in
            make.width.equalTo(timeStackView.snp.width).multipliedBy(0.5)
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
        
        //days
        daysView.snp.makeConstraints { make in
            make.top.equalTo(minuteView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        daysTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(daysView.snp.top).offset(10)
            make.leading.equalTo(daysView.snp.leading).offset(10)
            make.height.equalTo(20)
        }
//        daysStackView.snp.makeConstraints { make in
//            make.top.equalTo(daysTitleLabel.snp.bottom).offset(10)
//            make.leading.equalTo(daysView.snp.leading).offset(5)
//            make.trailing.equalTo(daysView.snp.trailing).offset(-5)
//            make.bottom.equalTo(daysView.snp.bottom).offset(-5)
//        }
        mondayButton.snp.makeConstraints { make in
            make.top.equalTo(daysTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(daysView.snp.leading).offset(50)
        }
        tuesdayButton.snp.makeConstraints { make in
            make.top.equalTo(mondayButton.snp.bottom).offset(10)
            make.leading.equalTo(mondayButton.snp.leading)
        }
        wednesdayButton.snp.makeConstraints { make in
            make.top.equalTo(tuesdayButton.snp.bottom).offset(10)
            make.leading.equalTo(mondayButton.snp.leading)
        }
        thursdayButton.snp.makeConstraints { make in
            make.top.equalTo(wednesdayButton.snp.bottom).offset(10)
            make.leading.equalTo(mondayButton.snp.leading)
        }
        fridayButton.snp.makeConstraints { make in
            make.top.equalTo(daysTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(daysView.snp.leading).offset(200)
        }
        saturdayButton.snp.makeConstraints { make in
            make.top.equalTo(fridayButton.snp.bottom).offset(10)
            make.leading.equalTo(fridayButton.snp.leading)
        }
        sundayButton.snp.makeConstraints { make in
            make.top.equalTo(saturdayButton.snp.bottom).offset(10)
            make.leading.equalTo(fridayButton.snp.leading)
        }

        
        //name
        alarmNameView.snp.makeConstraints { make in
            make.top.equalTo(timeSelectView.snp.bottom).offset(10)
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
        //button
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(alarmNameView.snp.bottom).offset(10)
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
        }
        return cnt
    }
}

extension NewAlarmViewController: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        var string = ""
//        
//        if pickerView == hourPickerView {
//            string = "\(hourArray[row])"
//        } else if pickerView == minutePickerView {
//            string = "\(minuteArray[row])"
//        }
//        return string
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPickerView {
            selectedHour = pickerView.selectedRow(inComponent: 0)
        } else if pickerView == minutePickerView {
            selectedMinute = pickerView.selectedRow(inComponent: 0)
        }
    }
    
    // UIPickerViewDelegate method to change text color
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if pickerView == hourPickerView {
            string = "\(hourArray[row])"
            if traitCollection.userInterfaceStyle == .dark {
                attributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 30, weight: .bold)
                ]
            } else {
                attributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 30, weight: .bold)
                ]
            }
        } else if pickerView == minutePickerView {
            string = "\(minuteArray[row])"
            if traitCollection.userInterfaceStyle == .dark {
                attributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 30, weight: .bold)
                ]
            } else {
                attributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 30, weight: .bold)
                ]
            }
        }
        
        return NSAttributedString(string: string, attributes: attributes)
    }
}

extension NewAlarmViewController: UITextFieldDelegate {
    // MARK: - return시 키보드 닫기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
