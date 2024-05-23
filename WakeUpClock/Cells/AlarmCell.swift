//
//  AlarmCell.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/23/24.
//

import UIKit

// MARK: - AlarmCell
class AlarmCell: UITableViewCell {
    // MARK: - AlarmCell Properties
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let checkBox = UISwitch()
    var dayLabels = [UILabel]()
    let daysStackView = UIStackView()
    
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else { return }
            let mutableAlarm = alarm
            updateUI(with: mutableAlarm)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard #available(iOS 13.0, *) else { return }
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
            updateSwitchTintColor()
        }
    }
    
    // MARK: - Configuration
    func configure(with alarm: Alarm) {
        self.alarm = alarm
        titleLabel.text = alarm.title
        updateTimeLabelText(alarm.time)
        clearDayLabels()
        setupDayLabels(for: alarm.repeatDays)
        checkBox.isOn = alarm.isEnabled
        checkBox.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    
    let alarmUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "glassEffectColor")?.withAlphaComponent(0.3)
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        return view
    }()
    
    private let shadowLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5
        return layer
    }()
    
    let alarmTextStackUIView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    let alarmSetItemStackUIView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 8
        return stackView
    }()
    
    let customView: UIView = {
        let customView = UIView()
        customView.backgroundColor = .clear
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.widthAnchor.constraint(equalToConstant: 164).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return customView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        updateAppearance()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func updateUI(with alarm: Alarm) {
        titleLabel.text = alarm.title
        updateTimeLabelText(alarm.time)
        clearDayLabels()
        setupDayLabels(for: alarm.repeatDays)
        checkBox.isOn = alarm.isEnabled
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        print("Switch changed")
        
        guard var alarm = alarm else {
            print("Error: Alarm is nil")
            return
        }
        
        guard let viewController = findViewController() as? AlarmViewController else {
            print("Error: Unable to access AlarmViewController.")
            return
        }
        
        print("Function is executing")
        
        alarm.isEnabled = sender.isOn
        updateUI(with: alarm)
        
        viewController.updateAlarmEnabledState(alarm: alarm, isEnabled: alarm.isEnabled)
        if !alarm.isEnabled {
            viewController.cancelNotification(for: alarm)
        }
    }
    
    private func updateSwitchTintColor() {
        if #available(iOS 13.0, *) {
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            checkBox.onTintColor = isDarkMode ? UIColor(hex: "#BBD2FF") : UIColor(hex: "#7C9AD6")
        }
    }
    
    internal func updateTimeLabelText(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone =  NSTimeZone(name: "UTC") as TimeZone?
        timeLabel.text = formatter.string(from: date)
    }
    
    private func clearDayLabels() {
        for dayLabel in dayLabels {
            dayLabel.removeFromSuperview()
        }
        dayLabels.removeAll()
    }
    
    private func setupDayLabels(for repeatDays: [String]) {
        for arrangedSubview in daysStackView.arrangedSubviews {
            daysStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        let repeatDaysArray = ["M", "T", "W", "Th", "F", "St", "S"]
        
        for (index, isSelected) in repeatDays.enumerated() {
            if isSelected == "1" {
                let dayLabel = UILabel()
                dayLabel.text = repeatDaysArray[index]
                dayLabel.textAlignment = .center
                dayLabel.textColor = UIColor(named: "textColor")
                dayLabel.font = UIFont.systemFont(ofSize: 14)
                
                dayLabel.translatesAutoresizingMaskIntoConstraints = false
                dayLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
                
                daysStackView.addArrangedSubview(dayLabel)
                dayLabels.append(dayLabel)
            }
        }
        
        if daysStackView.superview == nil {
            customView.addSubview(daysStackView)
        }
        
        daysStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            daysStackView.topAnchor.constraint(equalTo: customView.topAnchor),
            daysStackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            daysStackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowLayer.frame = alarmUIView.bounds
        
        let shadowPath = UIBezierPath(roundedRect: alarmUIView.bounds, cornerRadius: 20)
        shadowLayer.shadowPath = shadowPath.cgPath
        
        updateSwitchTintColor()
    }
    
    // MARK: - setupViews
    private func setupViews() {
        contentView.addSubview(alarmUIView)
        alarmUIView.layer.insertSublayer(shadowLayer, at: 0)
        contentView.addSubview(alarmTextStackUIView)
        contentView.addSubview(alarmSetItemStackUIView)
        
        titleLabel.textColor = UIColor(named: "textColor")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.textColor = UIColor(named: "textColor")
        timeLabel.font = UIFont.boldSystemFont(ofSize: 32)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        alarmTextStackUIView.addArrangedSubview(titleLabel)
        alarmTextStackUIView.addArrangedSubview(timeLabel)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.thumbTintColor = UIColor(named: "mainActiveColor")
        checkBox.backgroundColor = .clear
        
        alarmSetItemStackUIView.addArrangedSubview(checkBox)
        alarmSetItemStackUIView.addArrangedSubview(customView)
        
        alarmUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmUIView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            alarmUIView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            alarmUIView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            alarmUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        alarmTextStackUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmTextStackUIView.leadingAnchor.constraint(equalTo: alarmUIView.leadingAnchor, constant: 20),
            alarmTextStackUIView.centerYAnchor.constraint(equalTo: alarmUIView.centerYAnchor, constant: 2),
            alarmTextStackUIView.widthAnchor.constraint(equalToConstant: 200),
            alarmTextStackUIView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        alarmSetItemStackUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmSetItemStackUIView.trailingAnchor.constraint(equalTo: alarmUIView.trailingAnchor, constant: -20),
            alarmSetItemStackUIView.centerYAnchor.constraint(equalTo: alarmUIView.centerYAnchor, constant: 2),
            alarmSetItemStackUIView.widthAnchor.constraint(equalToConstant: 164),
            alarmSetItemStackUIView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func updateAppearance() {
        alarmUIView.backgroundColor = UIColor(named: "glassEffectColor")?.withAlphaComponent(0.3)
        shadowLayer.shadowColor = UIColor(named: "frameColor")?.cgColor
        setNeedsLayout()
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
