//
//  ClockViewController.swift
//  WakeUpClock
//
//  Created by 정유진 on 5/13/24.
//

import UIKit
import SnapKit

class ClockViewController: UIViewController {

    var timeList = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier: "Europe/Paris")!,
        TimeZone(identifier: "America/New_York")!,
        TimeZone(identifier: "Asia/Tehran")!,
        TimeZone(identifier: "Asia/Vladivostok")!
    ]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupConstraints()
    }
    
    func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ClockCell.self, forCellWithReuseIdentifier: ClockCell.identifier)
        collectionView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.leading.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    
    }
    

}
extension ClockViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClockCell.identifier, for: indexPath) as? ClockCell else { return UICollectionViewCell() }
        
        let target = timeList[indexPath.item]
        cell.timeLabel.text = target.currentTime
        cell.timePeriodLabel.text = target.timePeriod
        cell.timeZoneLabel.text = target.city
        cell.timeOffsetLabel.text = target.timeOffset
        return cell
    }
    
}
extension ClockViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2
        return CGSize(width: width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
