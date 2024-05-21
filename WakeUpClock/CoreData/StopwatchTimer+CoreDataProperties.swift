//
//  StopwatchTimer+CoreDataProperties.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/20/24.
//
//

import Foundation
import CoreData


extension StopwatchTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StopwatchTimer> {
        return NSFetchRequest<StopwatchTimer>(entityName: "StopwatchTimer")
    }

    @NSManaged public var milliSeconds: String?
    @NSManaged public var minutes: String?
    @NSManaged public var seconds: String?

}

extension StopwatchTimer : Identifiable {

}
