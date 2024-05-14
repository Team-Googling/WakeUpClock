//
//  AlarmViewController.swift
//  WakeUpClock
//
//  Created by wxxd-fxrest on 5/13/24.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var loadingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLoadingView()
        
        tableView.layoutIfNeeded()
    }

    // MARK: - Setup Methods
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)

        tableView.register(AlarmCell.self, forCellReuseIdentifier: "AlarmCell")
    }

    func setupLoadingView() {
        loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.isHidden = true

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    }

    // MARK: - Trait Collection Change Handling
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            showLoadingView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tableView.reloadData()
                self.hideLoadingView(after: 0.2)
            }
        }
    }

    // MARK: - Loading View Control
    private func showLoadingView() {
        loadingView.isHidden = false
        view.bringSubviewToFront(loadingView)
    }

    private func hideLoadingView(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.loadingView.isHidden = true
        }
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

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

class AlarmCell: UITableViewCell {
    let alarmUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "glassEffectColor")?.withAlphaComponent(0.3)
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        return view
    }()
    
    private let shadowLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
        return layer
    }()
    
    let alarmTextStackUIView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()

    let alarmSetItemStackUIView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 8
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        updateAppearance()
        
        setNeedsLayout()
        layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Handling
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowLayer.frame = alarmUIView.bounds
        
        let shadowPath = UIBezierPath(roundedRect: alarmUIView.bounds, cornerRadius: 20)
        shadowLayer.shadowPath = shadowPath.cgPath
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }

    // MARK: - View Setup
    private func setupViews() {
        contentView.addSubview(alarmUIView)
        alarmUIView.layer.insertSublayer(shadowLayer, at: 0)
        contentView.addSubview(alarmTextStackUIView)
        contentView.addSubview(alarmSetItemStackUIView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.textColor = UIColor(named: "textColor")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = "00:00"
        timeLabel.textColor = UIColor(named: "textColor")
        timeLabel.font = UIFont.boldSystemFont(ofSize: 32)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        alarmTextStackUIView.addArrangedSubview(titleLabel)
        alarmTextStackUIView.addArrangedSubview(timeLabel)
        
        let checkBox = UISwitch()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 32).isActive = true
        checkBox.onTintColor = .white
        checkBox.thumbTintColor = UIColor(named: "mainActiveColor")
        checkBox.backgroundColor = .clear

        alarmSetItemStackUIView.addArrangedSubview(checkBox)
        
        let customView = UIView()
        customView.backgroundColor = .clear
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.widthAnchor.constraint(equalToConstant: 164).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 22).isActive = true

        let daysStackView = UIStackView()
        daysStackView.axis = .horizontal
        daysStackView.spacing = 4
        daysStackView.alignment = .fill
        daysStackView.distribution = .fillEqually

        let dayLabels = ["M", "T", "W", "Th", "F", "St", "S"]

        for day in dayLabels {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.textColor = UIColor(named: "textColor")
            label.font = UIFont.systemFont(ofSize: 14)
            daysStackView.addArrangedSubview(label)
        }

        customView.addSubview(daysStackView)

        daysStackView.translatesAutoresizingMaskIntoConstraints = false
        daysStackView.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
        daysStackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor).isActive = true
        daysStackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor).isActive = true
        daysStackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true

        alarmSetItemStackUIView.addArrangedSubview(customView)
        
        alarmUIView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }

        alarmTextStackUIView.snp.makeConstraints {
            $0.leading.equalTo(alarmUIView.snp.leading).offset(20)
            $0.centerY.equalTo(alarmUIView).offset(5)
            $0.width.equalTo(100)
            $0.height.equalTo(60)
        }

        alarmSetItemStackUIView.snp.makeConstraints {
            $0.trailing.equalTo(alarmUIView.snp.trailing).offset(-20)
            $0.centerY.equalTo(alarmUIView)
            $0.width.equalTo(164)
            $0.height.equalTo(60)
        }
    }

    // MARK: - Appearance Update
    private func updateAppearance() {
        alarmUIView.backgroundColor = UIColor(named: "glassEffectColor")?.withAlphaComponent(0.3)
        shadowLayer.shadowColor = UIColor(named: "frameColor")?.cgColor
        setNeedsLayout()
    }
}

