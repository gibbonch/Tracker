//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UICollectionViewDiffableDataSource<TrackerCategorySection, TrackerItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TrackerCategorySection, TrackerItem>
    
    // MARK: - Properties
    
    private let trackersViewModel: TrackersViewModel
    private var trackersCollectionViewDelegate: TrackersCollectionViewDelegate?
    private var trackersCollectionViewDataSource: DataSource?
    
    // MARK: - Subviews
    
    private lazy var addTrackerBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .plus, style: .plain, target: self, action: #selector(didTapAddTrackerButton))
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
    
    private lazy var trackersCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 32) / 2 - 4.5, height: 148)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 9
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: (view.frame.width - 32) / 2, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: trackersCollectionViewFlowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        trackersCollectionViewDelegate = TrackersCollectionViewDelegate(viewModel: trackersViewModel, parentViewController: self)
        collectionView.delegate = trackersCollectionViewDelegate
        return collectionView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: TrackersViewModel) {
        self.trackersViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Трекеры", image: .trackers, selectedImage: nil)
        (trackersViewModel as? DefaultTrackersViewModel)?.delegate = self
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
        registerReusableViews()
        setupDataSource()
        applySnapshot()
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
    
    private func registerReusableViews() {
        trackersCollectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        
        trackersCollectionView.register(
            TrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderView.identifier
        )
    }
    
    private func setupDataSource() {
        trackersCollectionViewDataSource = DataSource(collectionView: trackersCollectionView) { [weak self] collectionView, indexPath, trackerItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath)
            guard let trackerCell = cell as? TrackerCollectionViewCell,
                  let trackerCellViewModel = self?.trackersViewModel.createTrackerCellViewModel(tracker: trackerItem.tracker, isPinned: trackerItem.isPinned)
            else { return cell }
            
            trackerCell.setupCell(viewModel: trackerCellViewModel)
            return trackerCell
        }
        
        trackersCollectionViewDataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerHeaderView.identifier,
                for: indexPath
            )
            
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = supplementaryView as? TrackerHeaderView,
                  let dataSource = self?.trackersCollectionViewDataSource
            else { return supplementaryView }
            
            let snapshot = dataSource.snapshot()
            let category = snapshot.sectionIdentifiers[indexPath.section]
            
            switch category {
            case .section(let title):
                headerView.setupHeaderView(category: title)
            }
            
            return headerView
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        guard let trackersCollectionViewDataSource else { return }
        
        var snapshot = Snapshot()
        for category in trackersViewModel.visibleCategories {
            let section = TrackerCategorySection.section(title: category.title)
            let items = category.trackers.map { tracker in
                TrackerItem(tracker: tracker, isPinned: category.title == Constants.pinnedCategoryTitle)
            }
            
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        
        trackersCollectionViewDataSource.apply(snapshot, animatingDifferences: true)

        if snapshot.numberOfItems == 0 {
            showPlaceholderView()
        } else {
            showTrackersCollectionView()
        }
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
    
    // MARK: - Objc Methods
    
    @objc private func didTapAddTrackerButton() {
        let trackerCreationViewController = TrackerCreationViewController()
        present(trackerCreationViewController, animated: true)
    }
    
    @objc private func datePickerValueChanged() {
        trackersViewModel.date = Calendar.current.startOfDay(for: datePicker.date) 
    }
    
    @objc private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
        searchController.dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        trackersViewModel.searchText = searchText
    }
}

// MARK: - DefaultTrackersViewModelDelegate

extension TrackersViewController: DefaultTrackersViewModelDelegate {
    func didUpdateVisibleCategories() {
        applySnapshot()
    }
}
