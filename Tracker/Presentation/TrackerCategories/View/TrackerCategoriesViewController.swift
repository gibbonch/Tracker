//
//  TrackerCategoriesViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 17.01.2025.
//

import UIKit

final class TrackerCategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: TrackerCategoriesViewModel
    private let cellHeight: CGFloat = 75.0
    
    // MARK: - Subviews
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
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
        scrollView.isHidden = viewModel.categoryTitles.count == 0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var placeholderView: PlaceholderView = {
        let placeholder = PlaceholderView()
        placeholder.setImage(.trackersPlaceholder)
        placeholder.setTitle("Привычки и события можно\nобъединить по смыслу")
        placeholder.isHidden = viewModel.categoryTitles.count != 0
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()
    
    private var categoriesTableViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var createCategoryButton = FilledButton(title: "Добавить категорию") { [weak self] in
        guard let self else { return }
        
        let categoryEditingViewModel = viewModel.createCategoryEditingViewModel(indexPath: nil)
        present(CategoryEditingViewController(viewModel: categoryEditingViewModel), animated: true)
    }
    
    // MARK: - Initializer
    
    init(viewModel: TrackerCategoriesViewModel) {
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
        setupLayout()
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(headerLabel, scrollView, createCategoryButton, placeholderView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(categoriesTableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor, constant: -24),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            categoriesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoriesTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
        ])
        
        categoriesTableViewHeightConstraint = categoriesTableView.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(viewModel.categoryTitles.count))
        categoriesTableViewHeightConstraint?.isActive = true
        contentView.bottomAnchor.constraint(equalTo: categoriesTableView.bottomAnchor, constant: 24).isActive = true
    }
    
    private func setupBindings() {
        viewModel.onChangeExistingCategories = { [weak self] categoriesChanges in
            guard let self else { return }
            
            let isTableEmpty = viewModel.categoryTitles.isEmpty
            scrollView.isHidden = isTableEmpty
            placeholderView.isHidden = !isTableEmpty
            
            let targetHeight = cellHeight * CGFloat(viewModel.categoryTitles.count)
            UIView.animate(withDuration: 0.3, animations: {
                self.categoriesTableViewHeightConstraint?.constant = targetHeight
                self.view.layoutIfNeeded()
            })
            
            categoriesTableView.performBatchUpdates { [weak self] in
                let insertedIndexPaths = categoriesChanges.insertedIndices.map { IndexPath(row: $0, section: 0) }
                let deletedIndexPaths = categoriesChanges.deletedIndices.map { IndexPath(row: $0, section: 0) }
                
                self?.categoriesTableView.insertRows(at: insertedIndexPaths, with: .fade)
                self?.categoriesTableView.deleteRows(at: deletedIndexPaths, with: .fade)
            } completion: { _ in
                let count = self.viewModel.categoryTitles.count
                if count > 1 {
                    let lastIndexPath = IndexPath(row: count - 1, section: 0)
                    let secondLastIndexPath = IndexPath(row: count - 2, section: 0)
                    self.categoriesTableView.reloadRows(at: [lastIndexPath, secondLastIndexPath], with: .none)
                } else if count == 1 {
                    let lastIndexPath = IndexPath(row: 0, section: 0)
                    self.categoriesTableView.reloadRows(at: [lastIndexPath], with: .none)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension TrackerCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath)
        
        guard let categoryCell = cell as? CategoryTableViewCell else {
            return cell
        }
        
        let isSelected = viewModel.isSelectedCategory(at: indexPath)
        categoryCell.setupCell(title: viewModel.categoryTitles[indexPath.row], isSelected: isSelected)
        if isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return categoryCell
    }
}

// MARK: - UITableViewDelegate

extension TrackerCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        viewModel.didSelectCategory(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать") { [weak self] _ in
                guard let self else { return }
                let categoryEditingViewModel = viewModel.createCategoryEditingViewModel(indexPath: indexPath)
                present(CategoryEditingViewController(viewModel: categoryEditingViewModel), animated: true)
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.presentDeletionAlertForCell(at: indexPath)
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    private func presentDeletionAlertForCell(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Эта категория точно не нужна?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
