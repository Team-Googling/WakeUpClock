//
//  TabBarController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit

class TabBarViewController: UITabBarController {
    let setInterfaceStyle = "interfaceStyle"
    var interfaceStyle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTabItem()
        
        // UserDefaults에 저장된 다크모드/라이트 값을 가져와 어플리케이션의 인터페이스 설정
        interfaceStyle = UserDefaults.standard.string(forKey: setInterfaceStyle) ?? "light"
        overrideUserInterfaceStyle = interfaceStyle == "dark" ? .dark : .light
        print(interfaceStyle)
        
        if let viewControllers = viewControllers as? [UINavigationController] {
            for navigationController in viewControllers {
                configureNavigationBar(navigationController)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            let animation = CATransition()
            animation.duration = 0.3
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.type = .fade
            tabBar.layer.add(animation, forKey: nil)
            self.configureTabItem()
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor(named: "backGroudColor")
        self.tabBar.backgroundColor = UIColor(named: "frameColor")
        self.tabBar.barTintColor = UIColor(named: "backGroudColor")
        self.tabBar.tintColor = UIColor(named: "mainActiveColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "textColor")
        
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
            clockNav.tabBarItem.selectedImage = UIImage(named: "dark-clock-1")
        }
        
        if let alarmIcon = UIImage(named: "dark-alarm-clock")?.resized(to: iconSize) {
            alarmNav.tabBarItem.image = alarmIcon
            alarmNav.tabBarItem.selectedImage = UIImage(named: "dark-alarm-clock-full")
        }
        
        if let timerIcon = UIImage(named: "dark-hourglass-empty")?.resized(to: iconSize) {
            timerNav.tabBarItem.image = timerIcon
            timerNav.tabBarItem.selectedImage = UIImage(named: "dark-hourglass-full")
        }
        
        if let stopwatchIcon = UIImage(named: "dark-timer")?.resized(to: iconSize2) {
            stopNav.tabBarItem.image = stopwatchIcon
            stopNav.tabBarItem.selectedImage = UIImage(named: "timer-full")
        }
        
        configureNavigationBar(clockNav)
        configureNavigationBar(alarmNav)
        configureNavigationBar(timerNav)
        configureNavigationBar(stopNav)
        
        self.setViewControllers([clockNav, alarmNav, timerNav, stopNav], animated: false)
    }
    
    private func configureNavigationBar(_ navigationController: UINavigationController) {
        guard let modeImage = interfaceStyle == "dark" ? UIImage(named: "dark-sleep-cycle") : UIImage(named: "sleep-cycle"),
              let moreImage = interfaceStyle == "dark" ? UIImage(named: "dark-plus") : UIImage(named: "plus") else {
            return
        }
        
        // Mode 버튼 설정
        let resizedModeImage = modeImage.resized(to: CGSize(width: 30, height: 20))
        let modeImageView = UIImageView(image: resizedModeImage)
        
        let modeButton = UIButton(type: .custom)
        modeButton.setImage(resizedModeImage, for: .normal)
        modeButton.addTarget(self, action: #selector(didTapModeButton), for: .touchUpInside)
        let modeItem = UIBarButtonItem(customView: modeButton)
        
        let moreButton = UIButton(type: .custom)
        moreButton.setImage(moreImage, for: .normal)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        let moreItem = UIBarButtonItem(customView: moreButton)
        
        navigationController.topViewController?.navigationItem.leftBarButtonItem = modeItem
        navigationController.topViewController?.navigationItem.rightBarButtonItem = moreItem
        
        let navBar = navigationController.navigationBar
        navBar.barTintColor = UIColor(named: "frameColor")
        navBar.isTranslucent = false
        navBar.backgroundColor = UIColor(named: "frameColor")
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
    }
    
    @objc private func didTapModeButton() {
        if #available(iOS 13.0, *) {
            let userInterfaceStyle: UIUserInterfaceStyle = traitCollection.userInterfaceStyle == .dark ? .light : .dark
            overrideUserInterfaceStyle = userInterfaceStyle
            
            interfaceStyle = userInterfaceStyle == .dark ? "dark" : "light"
            
            // UserDefaults에 수동 설정한 다크모드/라이트 값 저장
            UserDefaults.standard.set(interfaceStyle, forKey: setInterfaceStyle)
            
            if let viewControllers = viewControllers as? [UINavigationController] {
                for navigationController in viewControllers {
                    configureNavigationBar(navigationController)
                }
            }
        }
    }
    
    @objc private func didTapMoreButton() {
        print("More button tapped")
        
        let newAlarmVC = NewAlarmViewController()
        present(newAlarmVC, animated: true, completion: nil)
    }
}
