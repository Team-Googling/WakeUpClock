//
//  StopwatchLap+CoreDataProperties.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/20/24.
//
//

import Foundation
import CoreData


extension StopwatchLap {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StopwatchLap> {
        return NSFetchRequest<StopwatchLap>(entityName: "StopwatchLap")
    }

    @NSManaged public var diffTime: String?
    @NSManaged public var lapNumber: Int64
    @NSManaged public var recordTime: String?

}

extension StopwatchLap : Identifiable {

}
