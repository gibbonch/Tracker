//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController, MainTabBarViewController {
    
    // MARK: - Properties
    
    var mainTabBarItem = UITabBarItem(title: "Трекеры", image: .trackers, selectedImage: nil)
    
    private let viewModel: TrackersViewModel
    private var trackersCollectionViewManager: TrackersDataSourceManager?
    private var trackersCollectionViewDelegate: TrackersCollectionViewDelegate?
    
    // MARK: - Subviews
    
    private lazy var addTrackerBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .plus, style: .plain, target: self, action: #selector(addTrackerButtonTapped))
        button.tintColor = .blackApp
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru-RU")
        datePicker.calendar.firstWeekday = 2
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var placeholderView: PlaceholderView = {
        let placeholder = PlaceholderView()
        placeholder.isHidden = true
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        trackersCollectionViewDelegate?.layoutConfiguration = prepareLayoutConfiguration()
        trackersCollectionViewDelegate?.parentViewController = self
        collectionView.delegate = trackersCollectionViewDelegate
        trackersCollectionViewManager = TrackersDataSourceManager(collectionView: collectionView, viewModel: viewModel)
        trackersCollectionViewManager?.delegate = self
        return collectionView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: TrackersViewModel) {
        self.viewModel = viewModel
        trackersCollectionViewDelegate = TrackersCollectionViewDelegate(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationItem.leftBarButtonItem = addTrackerBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchController
        
        let disableTitleReducingView = UIView()
        view.addSubview(disableTitleReducingView)
        view.sendSubviewToBack(disableTitleReducingView)
    }
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        view.addSubviews(trackersCollectionView, placeholderView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func prepareLayoutConfiguration() -> CollectionViewLayoutConfiguration {
        CollectionViewLayoutConfiguration(
            cellsPerLine: 2,
            amountWidth: view.frame.width,
            cellHeight: 148,
            minimumLineSpacing: 0,
            minimumInteritemSpacing: 9,
            headerHeight: 40,
            sectionInsets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        )
    }
    
    // MARK: - Objc Methods
    
    @objc private func addTrackerButtonTapped() {
        let trackerCreationViewController = AppDIContainer.shared.createTrackerCreationViewController()
        (trackerCreationViewController as? TrackerCreationViewController)?.delegate = self
        present(trackerCreationViewController, animated: true)
    }
    
    @objc private func datePickerValueChanged() {
        viewModel.updateDate(datePicker.date)
    }
    
    @objc private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
        searchController.dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
    }
}

// MARK: - TrackersDataSourceManagerDelegate

extension TrackersViewController: TrackersDataSourceManagerDelegate {
    func didApplySnapshot(itemCount: Int) {
        itemCount == 0 ? showPlaceholderView() : showTrackersCollectionView()
    }
    
    private func showTrackersCollectionView() {
        placeholderView.isHidden = true
        UIView.transition(with: trackersCollectionView, duration: 0.3, options: .transitionCrossDissolve) {
            self.trackersCollectionView.isHidden = false
        }
    }
    
    private func showPlaceholderView() {
        trackersCollectionView.isHidden = true
        placeholderView.setImage(searchController.searchBar.text?.isEmpty == true ? .trackersPlaceholder : .searchPlaceholder)
        placeholderView.setTitle(searchController.searchBar.text?.isEmpty == true ? "Что будем отслеживать?" : "Ничего не найдено")
        placeholderView.isHidden = false
    }
}

// MARK: - TrackerCreationViewControllerDelegate

extension TrackersViewController: TrackerCreationViewControllerDelegate {
    func viewWillDismiss() {
        viewModel.viewWillAppear()
    }
}
