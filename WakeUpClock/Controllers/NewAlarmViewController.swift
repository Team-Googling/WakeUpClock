//
//  NewAlarmViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit

class NewAlarmViewController: UIViewController {
    //let daysArray: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday" , "Friday", "Saturday"]
    private var hourArray: [Int] = []
    private var minuteArray: [Int] = []
    
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
        view.layer.borderColor = UIColor(named: "frameColor")?.cgColor
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
    
    // MARK: - 날짜 선택
//    var daysPickerView: UIPickerView = {
//        let pickerView = UIPickerView()
//        return pickerView
//    }()

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
    
    private var preferencesView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private var preferencesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preferences"
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 버튼을 담을 스택 뷰
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
//        stackView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        stackView.layer.borderWidth = 1
//        stackView.layer.cornerRadius = 10
//        stackView.clipsToBounds = true
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
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourPickerView.dataSource = self
        minutePickerView.dataSource = self
        hourPickerView.delegate = self
        minutePickerView.delegate = self
    
        for i in 0...23 {
            hourArray.append(i)
        }
        for i in 0...59 {
            minuteArray.append(i)
        }
        
        setupAddView()
        setupAutoLayout()
    }
    
    // MARK: - 취소 버튼 선택
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        print("취소버튼 선택")
        //dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 완료 버튼 선택
    @objc private func doneButtonTapped(_ sender: UIButton) {
        print("완료버튼 선택")
    }
    
    // MARK: - 날짜 버튼 선택
    @objc private func dayButtonTapped(_ sender: UIButton) {
        guard let day = sender.currentTitle else { return }
        print("선택한 날짜: \(day)")
        
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
//        daysView.addSubview(daysPickerView)
        daysView.addSubview(daysStackView)
        for day in [" Sun", " Mon", " Tue", " Wed", " Thu", " Fri", " Sat"] {
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
            //make.height.equalTo(timeSelectView.snp.height).multipliedBy(0.3)
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
        
//        daysPickerView.snp.makeConstraints { make in
//            make.centerX.equalTo(daysView.snp.centerX)
//            make.centerY.equalTo(daysView.snp.centerY)
//        }
        
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
        
        preferencesView.snp.makeConstraints { make in
            make.top.equalTo(alarmNameView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        preferencesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(preferencesView.snp.top).offset(10)
            make.leading.equalTo(preferencesView.snp.leading).offset(10)
            make.trailing.equalTo(preferencesView.snp.trailing).offset(-10)
        }
         
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
        }
        
        return string
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        var title: String = ""
//        
//        if pickerView == hourPickerView {
//            title = String(hourArray[row])
//        } else if pickerView == minutePickerView {
//            title = String(minuteArray[row])
//        }
//        
//        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        return attributedString
//    }
}
