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
    static let lapEntity = "StopwatchLap"
    
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
    
    func saveLap(lapNumber: Int64, recordTime: String, diffTime: String) {
        guard let context = context else { return }
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: StopwatchCoreDataManager.lapEntity, in: context) else { return }
        
        let newLap = StopwatchLap(entity: entityDescription, insertInto: context)
        
        newLap.lapNumber = lapNumber
        newLap.recordTime = recordTime
        newLap.diffTime = diffTime
        
        do {
            print("save lap successfully")
            try context.save()
        } catch {
            print("Failed to save lap: \(error)")
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

    func fetchAllLaps() -> [StopwatchLap]? {
        guard let context = context else { return nil }
        let fetchRequest = NSFetchRequest<StopwatchLap>(entityName: StopwatchCoreDataManager.lapEntity)
        
        do {
            let laps = try context.fetch(fetchRequest)
            return laps
        } catch {
            print("Failed to fetch laps: \(error)")
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
    
    func deleteAllLaps() {
        guard let context = context else { return }
        
        let fetchRequest: NSFetchRequest<StopwatchLap> = StopwatchLap.fetchRequest()
        
        do {
            let laps = try context.fetch(fetchRequest)
            for lap in laps {
                context.delete(lap)
            }
            try context.save()
            print("deleted all laps successfully.")
        } catch {
            print("Failed to delete all laps: \(error)")
        }
    }
}



