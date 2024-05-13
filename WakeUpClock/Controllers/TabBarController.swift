//
//  TabBarController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTabItem()
    
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor(red: CGFloat(13)/255.0, green: CGFloat(13)/255.0, blue: CGFloat(37)/255.0, alpha: 1.0)
        self.tabBar.backgroundColor = UIColor(red: CGFloat(44)/255.0, green: CGFloat(44)/255.0, blue: CGFloat(69)/255.0, alpha: 1.0)
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .orange
    }
    
    func configureTabItem() {

        let clockVC  = ClockViewController()
        let alarmVC = AlarmViewController()
        let timerVC = TimerViewController()
        let stopVC = StopwatchViewController()
        
        let clockNav = UINavigationController(rootViewController: clockVC)
        let alarmNav = UINavigationController(rootViewController: alarmVC)
        let timerNav = UINavigationController(rootViewController: timerVC)
        let stopNav = UINavigationController(rootViewController: stopVC)
        
        clockNav.tabBarItem.title = "Clock"
        alarmNav.tabBarItem.title = "Alarm"
        timerNav.tabBarItem.title = "Timer"
        stopNav.tabBarItem.title = "Stopwatch"

        let iconSize = CGSize(width: 24, height: 24)

        if let alarmIcon = UIImage(named: "alarmIcon")?.resized(to: iconSize) {
            alarmNav.tabBarItem.image = alarmIcon
        }

        if let timerIcon = UIImage(named: "timerIcon")?.resized(to: iconSize) {
            timerNav.tabBarItem.image = timerIcon
        }

        if let stopwatchIcon = UIImage(named: "stopwatchIcon")?.resized(to: iconSize) {
            stopNav.tabBarItem.image = stopwatchIcon
        }

        if let clockIcon = UIImage(named: "clockIcon")?.resized(to: iconSize) {
            clockNav.tabBarItem.image = clockIcon
        }

        configureNavigationBar(for: clockNav)
        configureNavigationBar(for: alarmNav)
        configureNavigationBar(for: timerNav)
        configureNavigationBar(for: stopNav)
        
        self.setViewControllers([clockNav, alarmNav, timerNav, stopNav], animated: false)
    }
    
    func configureNavigationBar(for navigationController: UINavigationController) {
        navigationController.navigationBar.barTintColor = UIColor(red: CGFloat(44)/255.0, green: CGFloat(44)/255.0, blue: CGFloat(69)/255.0, alpha: 1.0)
    }
    
}
