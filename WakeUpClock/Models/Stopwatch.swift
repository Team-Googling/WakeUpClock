//
//  Stopwatch.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/14/24.
//

import Foundation

class Stopwatch: NSObject {
    var counter: Double
    var timer: Timer
    
    override init() {
        counter = 0.0
        timer = Timer()
    }
}
