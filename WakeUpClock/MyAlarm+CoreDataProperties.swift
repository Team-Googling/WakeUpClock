//
//  MyAlarm+CoreDataProperties.swift
//  WakeUpClock
//
//  Created by imhs on 5/17/24.
//
//

import Foundation
import CoreData


extension MyAlarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyAlarm> {
        return NSFetchRequest<MyAlarm>(entityName: "MyAlarm")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isEnabled: Bool
    @NSManaged public var isSnooze: Bool
    @NSManaged public var isVibration: Bool
    @NSManaged public var repeatDays: [Bool]?
    @NSManaged public var sound: String?
    @NSManaged public var time: Date?
    @NSManaged public var title: String?

}

extension MyAlarm : Identifiable {

}
