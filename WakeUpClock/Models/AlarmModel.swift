//
//  AlarmModel.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import Foundation

struct Alarm {
    var id: UUID
    var time: Date
    var repeatDays: [String]
    var title: String
    var isEnabled: Bool
    var sound: String
}
