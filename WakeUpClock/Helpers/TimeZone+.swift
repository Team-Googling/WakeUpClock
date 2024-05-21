//
//  TimeZone+.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/21/24.
//

import Foundation

fileprivate let formatter = DateFormatter()
fileprivate let offsetFormatter = DateComponentsFormatter()

extension TimeZone {
    // 현재 시간을 타임존 시간으로 포맷
    var currentTime: String? {
        formatter.timeZone = self
        formatter.dateFormat = "h:mm"
        
        return formatter.string(from: .now)
    }
    
    // 오전 오후 시간
    var timePeriod: String? {
        formatter.timeZone = self
        formatter.dateFormat = "a"
        
        return formatter.string(from: .now)
    }
    
    // 도시 이름
    var city: String? {
        // Asia/Souel 형태 -> 도시 이름만 추출되도록!
        let id = identifier
        let city = id.components(separatedBy: "/").last
        
        return city
    }
    
    // 시차
    var timeOffset: String? {
        // Timezone -> UTC -> 현재시간과 비교
        let offset = secondsFromGMT() - TimeZone.current.secondsFromGMT()
        let prefix = offset >= 0 ? "+" : ""
        
        let comp = DateComponents(second: offset)
        
        if offset.isMultiple(of: 3600) {
            offsetFormatter.allowedUnits = [.hour]
            offsetFormatter.unitsStyle = .full
        } else {
            offsetFormatter.allowedUnits = [.hour, .minute]
            offsetFormatter.unitsStyle = .positional
        }
        
        let offsetStr = offsetFormatter.string(from: comp) ?? "\(offset / 3600)시간"
        
        let time = Date(timeIntervalSinceNow: TimeInterval(offset))
        
        let cal = Calendar.current
        if cal.isDateInToday(time) {
            return "오늘, \(prefix)\(offsetStr)"
        } else if cal.isDateInYesterday(time) {
            return "어제, \(prefix)\(offsetStr)"
        } else if cal.isDateInTomorrow(time) {
            return "내일, \(prefix)\(offsetStr)"
        } else {
            return nil
        }
    }
}
