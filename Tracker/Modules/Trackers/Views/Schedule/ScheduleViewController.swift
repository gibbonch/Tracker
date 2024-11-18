//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 11.11.2024.
//

import UIKit

// MARK: - Protocol Definition

protocol ScheduleViewControllerDelegate: AnyObject {
    func didChange(schedule: [Day])
}

// MARK: - ScheduleViewController

final class ScheduleViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var delegate: ScheduleViewControllerDelegate?
    
    private let days = Day.allCases
    private var schedule = [Day]()
    
    // MARK: - Subviews
    
    private lazy var titleLabel = YPLabel(text: "Расписание",font: .ypMedium16)
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var applyButton = FilledButton(title: "Готово") { [weak self] in
        self?.dismiss(animated: true)
    }
    
    // MARK: - Initializer
    
    init(delegate: ScheduleViewControllerDelegate?, scheduleState: [Day] = [Day]()) {
        self.delegate = delegate
        self.schedule = scheduleState
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didChange(schedule: schedule)
    }
    
    // MARK: - Actions
    
    @objc private func daySwitchDidToggle(_ sender: UISwitch) {
        let day = days[sender.tag]
        updateScheduleState(for: day, isOn: sender.isOn)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        
        view.addSubviews(titleLabel, scheduleTableView, applyButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateScheduleState(for day: Day, isOn: Bool) {
        if isOn && !schedule.contains(day)  {
            schedule.append(day)
        } else {
            schedule.removeAll { $0 == day }
        }
        schedule.sort(by: { $0.rawValue < $1.rawValue })
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath)
        guard let scheduleCell = cell as? ScheduleTableViewCell else {
            return cell
        }
        scheduleCell.selectionStyle = .none
        scheduleCell.dayLabel.text = days[indexPath.row].toString()
        scheduleCell.daySwitch.addTarget(self, action: #selector(daySwitchDidToggle), for: .valueChanged)
        scheduleCell.daySwitch.tag = indexPath.row
        return scheduleCell
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == days.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
}
