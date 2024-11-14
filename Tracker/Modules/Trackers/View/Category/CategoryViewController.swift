//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 14.11.2024.
//

import UIKit

protocol CategoryTableViewDelegate: AnyObject {
    func categoryTableView(_ tableView: UITableView, didSelectCategory category: String?)
}

final class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var delegate: CategoryTableViewDelegate?
    private var categories = ["Важное"]
    
    // MARK: - Subviews
    
    private lazy var titleLabel = YPLabel(text: "Категория", font: .ypMedium16)
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "category-cell")
        
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var categoryTableViewHeighConstraint: NSLayoutConstraint?
    
    // MARK: - Initializer
    
    init(delegate: CategoryTableViewDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(titleLabel, categoryTableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
        ])
        
        categoryTableViewHeighConstraint = categoryTableView.heightAnchor.constraint(equalToConstant: CGFloat(categories.count)  * CategoryTableViewCell.cellHeight)
        categoryTableViewHeighConstraint?.isActive = true
    }
    
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category-cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        delegate?.categoryTableView(tableView, didSelectCategory: cell?.textLabel?.text)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
