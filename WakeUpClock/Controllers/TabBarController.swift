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
    
    func configureUI() {
        self.view.backgroundColor = UIColor(red: CGFloat(13)/255.0, green: CGFloat(13)/255.0, blue: CGFloat(37)/255.0, alpha: 1.0)
        self.tabBar.backgroundColor = UIColor(red: CGFloat(44)/255.0, green: CGFloat(44)/255.0, blue: CGFloat(69)/255.0, alpha: 1.0)
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .orange
        
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 69/255, alpha: 1.0)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
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
        let iconSize2 = CGSize(width: 32, height: 32)
        
        if let clockIcon = UIImage(named: "clockIcon")?.resized(to: iconSize) {
            clockNav.tabBarItem.image = clockIcon
        }
        
        if let alarmIcon = UIImage(named: "alarmIcon")?.resized(to: iconSize) {
            alarmNav.tabBarItem.image = alarmIcon
        }
        
        if let timerIcon = UIImage(named: "timerIcon")?.resized(to: iconSize) {
            timerNav.tabBarItem.image = timerIcon
        }
        
        if let stopwatchIcon = UIImage(named: "stopwatchIcon")?.resized(to: iconSize2) {
            stopNav.tabBarItem.image = stopwatchIcon
        }
        
        configureNavigationBar(clockNav)
        configureNavigationBar(alarmNav)
        configureNavigationBar(timerNav)
        configureNavigationBar(stopNav)
        
        self.setViewControllers([clockNav, alarmNav, timerNav, stopNav], animated: false)
    }
    
    func configureNavigationBar(_ navigationController: UINavigationController) {
        guard let modeImage = UIImage(named: "modeImage"),
              let moreImage = UIImage(named: "moreImage") else {
            return
        }
        
        // Mode 버튼 설정
        let resizedModeImage = modeImage.resized(to: CGSize(width: 30, height: 20))
        let modeImageView = UIImageView(image: resizedModeImage)
        let modeItem = UIBarButtonItem(customView: modeImageView)
        
        // More 버튼 설정
        let resizedMoreImage = moreImage.resized(to: CGSize(width: 26, height: 26))
        let moreImageView = UIImageView(image: resizedMoreImage)
        let moreItem = UIBarButtonItem(customView: moreImageView)
        
        navigationController.topViewController?.navigationItem.leftBarButtonItem =  modeItem
        navigationController.topViewController?.navigationItem.rightBarButtonItem = moreItem
        navigationController.navigationBar.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 69/255, alpha: 1.0)
    }

    
}
