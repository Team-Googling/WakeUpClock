//
//  NewAlarmViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit

class NewAlarmViewController: UIViewController {
    let daysArray: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday" , "Friday", "Saturday"]
    
    // MARK: - 스크롤 뷰
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    // MARK: - 시간 관련 뷰
    var timeView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Select Time
    var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select time"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 날짜 관련 뷰
    var daysView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Days
    var daysTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Days"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - 날짜 선택
    var daysPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    // MARK: - 알람 이름 관련 뷰
    var alarmNameView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Name
    var alarmTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    var alarmNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        return textField
    }()
    
    var preferencesView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var preferencesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preferences"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = #colorLiteral(red: 0.1580777466, green: 0.1580777466, blue: 0.1580777466, alpha: 1)
        daysPickerView.dataSource = self
        daysPickerView.delegate = self
    
        setupAddView()
        setupAutoLayout()
    }
    
    // MARK: - addView
    func setupAddView() {
        view.addSubview(scrollView)
        
        //Select Time
        scrollView.addSubview(timeView)
        timeView.addSubview(timeTitleLabel)
        
        //Days
        scrollView.addSubview(daysView)
        daysView.addSubview(daysTitleLabel)
        daysView.addSubview(daysPickerView)
        
        //Name
        scrollView.addSubview(alarmNameView)
        alarmNameView.addSubview(alarmTitleLabel)
        alarmNameView.addSubview(alarmNameTextField)
        
        //preferences
        scrollView.addSubview(preferencesView)
        preferencesView.addSubview(preferencesTitleLabel)
    }
    
    // MARK: - 오토레이아웃 설정
    func setupAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        timeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        timeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeView.snp.top).inset(10)
            make.leading.equalTo(timeView.snp.leading).inset(10)
        }
        
        daysView.snp.makeConstraints { make in
            make.top.equalTo(timeView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        daysTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(daysView.snp.top).offset(10)
            make.leading.equalTo(daysView.snp.leading).offset(10)
        }
        
        daysPickerView.snp.makeConstraints { make in
            make.centerX.equalTo(daysView.snp.centerX)
            make.centerY.equalTo(daysView.snp.centerY)
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
    }
}


extension NewAlarmViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysArray.count
    }
}

extension NewAlarmViewController: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return daysArray[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = daysArray[row]
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return attributedString
    }
}
