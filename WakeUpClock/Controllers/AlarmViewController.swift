//
//  AlarmViewController.swift
//  WakeUpClock
//
//  Created by wxxd-fxrest on 5/13/24.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        tableView.register(AlarmCell.self, forCellReuseIdentifier: "AlarmCell")
    }

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        cell.backgroundColor = UIColor(named: "backGroudColor")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

class AlarmCell: UITableViewCell {
    let alarmUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "grassEffectColor")?.withAlphaComponent(0.3)
        view.frame = CGRect(x: 0, y: 0, width: 340, height: 100)
        view.layer.cornerRadius = 20
        view.clipsToBounds = false

        // Add shadow layer
        let shadowLayer = CALayer()
        shadowLayer.frame = CGRect(x: 0, y: 0, width: 340, height: 100)
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor(named: "frameColor")?.cgColor
        shadowLayer.shadowOpacity = 10
        shadowLayer.shadowOffset = CGSize(width: 0, height: 5)
        shadowLayer.shadowRadius = 5
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 370, height: 90), cornerRadius: 20)
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.position = view.center
        view.layer.insertSublayer(shadowLayer, at: 0)

        return view
    }()

    let alarmTextStackUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        return view
    }()

    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Alarm"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let alarmSetItemStackUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.frame = CGRect(x: 0, y: 0, width: 164, height: 60)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(alarmUIView)
        contentView.addSubview(alarmTextStackUIView)
        contentView.addSubview(testLabel)
        contentView.addSubview(alarmSetItemStackUIView)

        alarmUIView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }

        alarmTextStackUIView.snp.makeConstraints {
            $0.leading.equalTo(alarmUIView.snp.leading).offset(20)
            $0.centerY.equalTo(alarmUIView)
            $0.width.equalTo(100)
            $0.height.equalTo(60)
        }

        testLabel.snp.makeConstraints {
            $0.centerX.equalTo(alarmTextStackUIView.snp.centerX)
            $0.centerY.equalTo(alarmTextStackUIView.snp.centerY)
        }

        alarmSetItemStackUIView.snp.makeConstraints{
            $0.trailing.equalTo(alarmUIView.snp.trailing).offset(-20)
            $0.centerY.equalTo(alarmUIView)
            $0.width.equalTo(164)
            $0.height.equalTo(60)
        }
    }
}
