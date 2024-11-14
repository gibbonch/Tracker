//
//  ParametersTableView.swift
//  Tracker
//
//  Created by Александр Торопов on 11.11.2024.
//

import UIKit

struct Parameter {
    let title: String
    let details: String?
    
    init(title: String, details: String? = nil) {
        self.title = title
        self.details = details
    }
}

protocol ParametersTableViewDelegate: AnyObject {
    func parametersTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

final class ParametersTableView: UITableView {
    
    // MARK: - Properties
    
    private weak var parametersTableViewDelegate: ParametersTableViewDelegate?
    private var parameters = [Parameter]()
    
    // MARK: - Initializer
    
    init(parametersTableViewDelegate: ParametersTableViewDelegate? = nil, parameters: [Parameter]) {
        self.parametersTableViewDelegate = parametersTableViewDelegate
        self.parameters = parameters
        super.init(frame: .zero, style: .plain)
        setupTableView()
        configure(with: parameters)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with parameters: [Parameter]) {
        self.parameters = parameters
        reloadData()
    }
    
    private func setupTableView() {
        dataSource = self
        delegate = self
        register(UITableViewCell.self, forCellReuseIdentifier: "parameter-cell")
        
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

// MARK: - UITableViewDataSource

extension ParametersTableView: UITableViewDataSource {
    
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

extension ParametersTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parametersTableViewDelegate?.parametersTableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
