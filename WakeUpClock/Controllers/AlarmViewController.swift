//
//  AlarmViewController.swift
//  WakeUpClock
//
//  Created by wxxd-fxrest on 5/13/24.
//
//

import UIKit
import CoreData

class AlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    var tableView: UITableView!
    var loadingView: UIView!
    
    let formatter = DateFormatter()
    var alarms: [Alarm] = [] // Core Data에서 가져온 알람 데이터
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "HH:mm"
        
        // MARK: - UI Setup
        setupLoadingView()
        setupTableView()
        
        tableView.layoutIfNeeded()
        
        fetchAlarmsFromCoreData()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        // MARK: - Table View Setup
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(named: "backGroudColor")
        tableView.register(AlarmCell.self, forCellReuseIdentifier: "AlarmCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Loading View Setup
    func setupLoadingView() {
        loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.isHidden = true
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    }
    
    // MARK: - Trait Collection Change Handling
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            showLoadingView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tableView.reloadData()
                self.hideLoadingView(after: 0.2)
            }
        }
    }
    
    // MARK: - Loading View Control
    private func showLoadingView() {
        loadingView.isHidden = false
        view.bringSubviewToFront(loadingView)
    }
    
    private func hideLoadingView(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.loadingView.isHidden = true
        }
    }
    
    private func fetchAlarmsFromCoreData() {
        // Fetch data from Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: Unable to access AppDelegate.")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyAlarm")
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                guard let id = data.value(forKey: "id") as? UUID,
                      let time = data.value(forKey: "time") as? Date,
                      let repeatDays = data.value(forKey: "repeatDays") as? [Int], // 수정된 부분
                      let isEnabled = data.value(forKey: "isEnabled") as? Bool else {
                    print("Error: Failed to fetch alarm data. Some attributes are nil.")
                    print("Data: \(data)")
                    continue
                }
                
                print("timetime \(time)")
                
                var title = data.value(forKey: "title") as? String
                if title == nil || title?.isEmpty == true {
                    title = "Alarm"
                }
                
                print("Fetched alarm data:")
                print("ID: \(id)")
                print("Time: \(time)")
                print("Repeat Days: \(repeatDays)")
                print("Is Enabled: \(isEnabled)")
                print("Title: \(title ?? "N/A")")
                
                let alarm = Alarm(id: id, time: time, repeatDays: repeatDays.map { String($0) }, title: title ?? "Alarm", isEnabled: isEnabled, sound: "")
                alarms.append(alarm)
                print("alarmsalarms: \(alarm)")
                print("alarms count: \(alarms.count)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch data from Core Data: \(error.localizedDescription)")
        }
    }


    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        cell.backgroundColor = UIColor(named: "backGroudColor")
        
        let alarm = alarms[indexPath.row]
        cell.titleLabel.text = alarm.title
        cell.updateTimeLabelText(alarm.time)
        cell.configure(with: alarm)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: - Cell Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            self.deleteAlarmFromCoreData(at: indexPath.row)
            
            self.alarms.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completion(true)
        }
        
        deleteAction.backgroundColor = UIColor(named: "backGroudColor")
        let trashImage = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "textColor") ?? .gray, renderingMode: .alwaysOriginal)
        deleteAction.image = trashImage
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    // MARK: - Delete Alarm from Core Data
    private func deleteAlarmFromCoreData(at index: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyAlarm")
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > index {
                let objectToDelete = result[index] as! NSManagedObject
                context.delete(objectToDelete)
                
                try context.save()
            } else {
                print("Index out of bounds while deleting alarm from Core Data")
            }
        } catch {
            print("Failed to delete alarm from Core Data: \(error.localizedDescription)")
        }
    }
}

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
        checkBox.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        guard var alarm = alarm else { return }
        alarm.isEnabled = sender.isOn
        self.alarm = alarm
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
            alarmTextStackUIView.widthAnchor.constraint(equalToConstant: 100),
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
    
    private func updateAppearance() {
        alarmUIView.backgroundColor = UIColor(named: "glassEffectColor")?.withAlphaComponent(0.3)
        shadowLayer.shadowColor = UIColor(named: "frameColor")?.cgColor
        setNeedsLayout()
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        var trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedHex.hasPrefix("#") {
            trimmedHex.remove(at: trimmedHex.startIndex)
        }
        
        guard trimmedHex.count == 6 else { return nil }
        
        var rgb: UInt64 = 0
        Scanner(string: trimmedHex).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

