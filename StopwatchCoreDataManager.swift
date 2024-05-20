//
//  StopwatchCoreDataManager.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/17/24.
//

import CoreData
import UIKit

class StopwatchCoreDataManager {
    
    static let shared = StopwatchCoreDataManager()
    
    static let timerEntity = "StopwatchTimer"
    
    private let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate가 초기화되지 않았습니다.")
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Save
    func saveTime(minutes: String, seconds: String, milliSeconds: String) {
        guard let context = context else { return }
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: StopwatchCoreDataManager.timerEntity, in: context) else { return }
        
        let newTime = StopwatchTimer(entity: entityDescription, insertInto: context)
        
        newTime.minutes = minutes
        newTime.seconds = seconds
        newTime.milliSeconds = milliSeconds
        
        do {
            print("save time successfully")
            try context.save()
        } catch {
            print("Failed to save time: \(error)")
        }
    }
    
    // MARK: - Read
    func fetchAllTimes() -> [StopwatchTimer]? {
        guard let context = context else { return nil }
        let fetchRequest = NSFetchRequest<StopwatchTimer>(entityName: StopwatchCoreDataManager.timerEntity)
        
        do {
            let times = try context.fetch(fetchRequest)
            return times
        } catch {
            print("Failed to fetch times: \(error)")
            return nil
        }
    }
    
    // MARK: - Delete
    func deleteAllTimes() {
        guard let context = context else { return }
        
        let fetchRequest: NSFetchRequest<StopwatchTimer> = StopwatchTimer.fetchRequest()
        
        do {
            let times = try context.fetch(fetchRequest)
            for time in times {
                context.delete(time)
            }
            try context.save()
            print("deleted successfully.")
        } catch {
            print("Failed to delete all times: \(error)")
        }
    }

}



