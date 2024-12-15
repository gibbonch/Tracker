//
//  TrackerScheduleViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 12.12.2024.
//

import UIKit

class TrackerScheduleViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: TrackerScheduleViewModel
    private var weekdays = {
        var weekdays = Weekday.allCases
        Utilities.bringScheduleIntoRuFormat(&weekdays)
        return weekdays
    }()
    
    // MARK: - Subviews
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackApp
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var applyButton = FilledButton(title: "Готово") { [weak self] in
        self?.viewModel.didEndScheduleEditing()
        self?.dismiss(animated: true)
    }
    
    // MARK: - Initializer
    
    init(viewModel: TrackerScheduleViewModel) {
        self.viewModel = viewModel
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
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.didEndScheduleEditing()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(headerLabel, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(scheduleTableView, applyButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scheduleTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 75.0 * CGFloat(weekdays.count)),
            
            applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            applyButton.topAnchor.constraint(equalTo: scheduleTableView.bottomAnchor, constant: 40),
            applyButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        contentView.bottomAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: 24).isActive = true
    }
}

extension TrackerScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scheduleCell = ScheduleTableViewCell()
        let weekday = weekdays[indexPath.row]
        scheduleCell.setupCell(with: weekday, isSelected: viewModel.schedule.contains(weekday)) { [weak self] in
            self?.viewModel.didSelectWeekday(at: indexPath)
        }
        
        return scheduleCell
    }
}

extension TrackerScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
}
