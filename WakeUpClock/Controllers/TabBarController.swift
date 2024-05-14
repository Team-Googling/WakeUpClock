//
//  TabBarController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTabItem()
    
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor(named: "backGroudColor")
        self.tabBar.backgroundColor = UIColor(named: "frameColor")
        self.tabBar.barTintColor = UIColor(named: "mainTextColor")
        self.tabBar.tintColor = UIColor(named: "mainActiveColor")
        
        let topView = UIView()
        topView.backgroundColor = UIColor(named: "frameColor")
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func configureTabItem() {
        let clockNav = UINavigationController(rootViewController: ClockViewController())
        let alarmNav = UINavigationController(rootViewController: AlarmViewController())
        let timerNav = UINavigationController(rootViewController: TimerViewController())
        let stopNav = UINavigationController(rootViewController: StopwatchViewController())
        
        clockNav.tabBarItem.title = "Clock"
        alarmNav.tabBarItem.title = "Alarm"
        timerNav.tabBarItem.title = "Timer"
        stopNav.tabBarItem.title = "Stopwatch"
        
        let iconSize = CGSize(width: 24, height: 24)
        let iconSize2 = CGSize(width: 32, height: 32)
        
        if let clockIcon = UIImage(named: "dark-clock")?.resized(to: iconSize) {
            clockNav.tabBarItem.image = clockIcon
        }
        
        if let alarmIcon = UIImage(named: "dark-alarm-clock")?.resized(to: iconSize) {
            alarmNav.tabBarItem.image = alarmIcon
        }
        
        if let timerIcon = UIImage(named: "dark-hourglass-empty")?.resized(to: iconSize) {
            timerNav.tabBarItem.image = timerIcon
        }
        
        if let stopwatchIcon = UIImage(named: "dark-timer")?.resized(to: iconSize2) {
            stopNav.tabBarItem.image = stopwatchIcon
        }
        
        configureNavigationBar(clockNav)
        configureNavigationBar(alarmNav)
        configureNavigationBar(timerNav)
        configureNavigationBar(stopNav)
        
        self.setViewControllers([clockNav, alarmNav, timerNav, stopNav], animated: false)
    }
    
    private func configureNavigationBar(_ navigationController: UINavigationController) {
        guard let modeImage = UIImage(named: "dark-sleep-cycle"),
              let moreImage = UIImage(named: "dark-menu-dots-vertical") else {
            return
        }
        
        // Mode 버튼 설정
        let resizedModeImage = modeImage.resized(to: CGSize(width: 30, height: 20))
        let modeImageView = UIImageView(image: resizedModeImage)
        let modeItem = UIBarButtonItem(customView: modeImageView)
        
        // More 버튼 설정
        let resizedMoreImage = moreImage.resized(to: CGSize(width: 20, height: 20))
        let moreImageView = UIImageView(image: resizedMoreImage)
        let moreItem = UIBarButtonItem(customView: moreImageView)
        
        navigationController.topViewController?.navigationItem.leftBarButtonItem =  modeItem
        navigationController.topViewController?.navigationItem.rightBarButtonItem = moreItem
        navigationController.navigationBar.backgroundColor = UIColor(named: "frameColor")
    }
}
