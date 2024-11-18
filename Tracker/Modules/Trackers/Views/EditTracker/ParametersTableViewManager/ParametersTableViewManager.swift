//
//  ParametersTableViewManager.swift
//  Tracker
//
//  Created by Александр Торопов on 11.11.2024.
//

import UIKit

// MARK: - Protocol Definition

protocol ParametersTableViewManagerDelegate: AnyObject {
    func didSelectRow(at indexPath: IndexPath)
}

// MARK: - ParametersTableViewManager

final class ParametersTableViewManager: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: ParametersTableViewManagerDelegate?
    private var parameters = [Parameter]()
    
    // MARK: - Subviews
    
    private let tableView: UITableView
    
    // MARK: - Initializer
    
    init(tableView: UITableView, parameters: [Parameter]) {
        self.tableView = tableView
        self.parameters = parameters
        super.init()
        setupTableView()
        updateTableView(with: parameters)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateTableView(with parameters: [Parameter]) {
        self.parameters = parameters
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "parameter-cell")
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UITableViewDataSource

extension ParametersTableViewManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "parameter-cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        cell.textLabel?.text = parameters[indexPath.row].title
        cell.textLabel?.font = .ypRegular17
        
        cell.detailTextLabel?.text = parameters[indexPath.row].details ?? ""
        cell.detailTextLabel?.font = .ypRegular17
        cell.detailTextLabel?.textColor = .grayApp
        
        cell.backgroundColor = UIColor.lightGrayApp.withAlphaComponent(0.3)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ParametersTableViewManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == parameters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
}
