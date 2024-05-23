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
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "HH:mm"
        
        // MARK: - UI Setup
        setupLoadingView()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(modalDidDismiss), name: NSNotification.Name("ModalDidDismiss"), object: nil)
        
        fetchAlarmsFromCoreData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func modalDidDismiss() {
        fetchAlarmsFromCoreData() // 모달이 닫힐 때마다 데이터를 다시 가져옴
        print("Modal was closed")
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        // MARK: - Table View Setup
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(named: "backGroudColor")
        tableView.register(AlarmCell.self, forCellReuseIdentifier: "AlarmCell")
        tableView.allowsSelection = false
        
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
    
    // MARK: - fetchAlarmsFromCoreData
    func fetchAlarmsFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: Unable to access AppDelegate.")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyAlarm")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            alarms.removeAll()
            
            for data in result as! [NSManagedObject] {
                guard let id = data.value(forKey: "id") as? UUID,
                      let time = data.value(forKey: "time") as? Date,
                      let repeatDays = data.value(forKey: "repeatDays") as? [Int],
                      let isEnabled = data.value(forKey: "isEnabled") as? Bool else {
                    print("Error: Failed to fetch alarm data. Some attributes are nil.")
                    print("Data: \(data)")
                    continue
                }
                
                var title = data.value(forKey: "title") as? String
                if title == nil || title?.isEmpty == true {
                    title = "Alarm"
                }
                
                let alarm = Alarm(id: id, time: time, repeatDays: repeatDays.map { String($0) }, title: title ?? "Alarm", isEnabled: isEnabled, sound: "")
                alarms.append(alarm)
                
                // UNUserNotificationCenter를 사용하여 알람 설정
                scheduleNotification(for: alarm)
                print("alarm", alarm)
            }
            
            alarms.sort { $0.time < $1.time }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - UNUserNotificationCenter
    func scheduleNotification(for alarm: Alarm) {
        guard alarm.isEnabled else { return } // isEnabled가 false이면 알람 스케줄링하지 않음
        
        let timeZone = TimeZone(identifier: "UTC")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timeZone
        
        let localTime = formatter.string(from: alarm.time)
        
        let content = UNMutableNotificationContent()
        content.title = "WakeUpClock"
        content.body = "\(alarm.title): \(localTime)"
        content.sound = UNNotificationSound.default
        
        let components = localTime.components(separatedBy: ":")
        guard let hour = Int(components[0]), let minute = Int(components[1]) else {
            return
        }
        
        _ = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let repeatDays = alarm.repeatDays
        let daysToSound = [2, 3, 4, 5, 6, 7, 1]
        
        for (index, isSelected) in repeatDays.enumerated() {
            if alarm.isEnabled {
                let weekday = daysToSound[index]
                dateComponents.weekday = weekday
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: alarm.id.uuidString + isSelected, content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
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
            let alarmToDelete = self.alarms[indexPath.row]
            self.deleteAlarmFromCoreData(alarm: alarmToDelete)
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
    private func deleteAlarmFromCoreData(alarm: Alarm) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyAlarm")
        fetchRequest.predicate = NSPredicate(format: "id == %@", alarm.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let objectToDelete = result.first as? NSManagedObject {
                context.delete(objectToDelete)
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
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

// MARK: - AlarmViewController
extension AlarmViewController {
    func updateAlarmEnabledState(alarm: Alarm, isEnabled: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyAlarm")
        fetchRequest.predicate = NSPredicate(format: "id = %@", alarm.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            print("\(result)")
            
            if let objectToUpdate = result.first as? NSManagedObject {
                objectToUpdate.setValue(isEnabled, forKey: "isEnabled")
                try context.save()
                print("successful")
                
                // 알람이 isEnabled가 false일 때 알림 취소
                if !isEnabled {
                    cancelNotification(for: alarm)
                }
            }
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    
    func cancelNotification(for alarm: Alarm) {
        var array = [String]()
        for days in alarm.repeatDays {
            array.append(alarm.id.uuidString + days)
        }
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: array)
        print("Canceling for alarm with ID: \(array)")
    }
}

// MARK: - UNUserNotificationCenter Extension
extension UNUserNotificationCenter {
    func getPendingNotificationIDs() -> [String] {
        var notificationIDs: [String] = []
        getPendingNotificationRequests { requests in
            for request in requests {
                notificationIDs.append(request.identifier)
            }
        }
        return notificationIDs
    }
}
