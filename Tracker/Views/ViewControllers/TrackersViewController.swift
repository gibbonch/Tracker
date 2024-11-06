//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var placeHolderView: PlaceholderView = {
        let placeholderView = PlaceholderView(image: .trackersPlaceholder, message: "Что будем отслеживать?")
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Трекеры"
        setupNavigationBar()
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(placeHolderView)
        NSLayoutConstraint.activate([
            placeHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.hidesNavigationBarDuringPresentation = false
        navigationController?.navigationBar.topItem?.searchController = searchController
        
        let addTrackerBarButtonItem = UIBarButtonItem(image: .plus, style: .plain, target: nil, action: nil)
        addTrackerBarButtonItem.tintColor = .blackApp
        self.navigationItem.leftBarButtonItem = addTrackerBarButtonItem
        
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru-RU")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
}
