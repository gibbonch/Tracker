//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private lazy var placeHolderView: PlaceholderView = {
        let placeholderView = PlaceholderView(image: .trackersPlaceholder, message: "Что будем отслеживать?")
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
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
        
        let addTrackerBarButtonItem = UIBarButtonItem(image: .plus, style: .plain, target: self, action: #selector(addTrackerButtonTapped))
        addTrackerBarButtonItem.tintColor = .blackApp
        self.navigationItem.leftBarButtonItem = addTrackerBarButtonItem
        
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru-RU")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }

    // MARK: - Actions

    @objc private func addTrackerButtonTapped() {
        print("Add Tracker button tapped")
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print("Date selected: \(selectedDate)")
    }

}
