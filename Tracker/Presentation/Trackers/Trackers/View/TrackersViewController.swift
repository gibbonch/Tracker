//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - DiffableDataSource
    
    private typealias DataSource = UICollectionViewDiffableDataSource<TrackerCategorySection, TrackerItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TrackerCategorySection, TrackerItem>
    
    fileprivate enum TrackerCategorySection: Hashable {
        case section(title: String)
    }
    
    fileprivate struct TrackerItem: Hashable {
        let tracker: Tracker
        let isPinned: Bool
    }
    
    // MARK: - Properties
    
    private let trackersViewModel: TrackersViewModel
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
        let screenWidth = UIScreen.main.bounds.width
        let hSectionInset = 16.0
        let itemsPerLine = 2.0
        let interItemSpacing = 9.0
        layout.itemSize = CGSize(width: (screenWidth - hSectionInset * 2 - interItemSpacing) / itemsPerLine, height: 148)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = interItemSpacing
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: screenWidth - hSectionInset * 2, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: hSectionInset, bottom: 0, right: hSectionInset)
        return layout
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: trackersCollectionViewFlowLayout)
        collectionView.delegate = self
        collectionView.register(TrackerCollectionViewCell.self,
                                        forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerHeaderView.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: TrackerHeaderView.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: TrackersViewModel) {
        self.trackersViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Трекеры", image: .trackers, selectedImage: nil)
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
        setupLayout()
        setupDataSource()
        bind()
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
        view.addSubviews(trackersCollectionView, placeholderView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    private func setupLayout() {
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
    
    private func setupDataSource() {
        trackersCollectionViewDataSource = DataSource(collectionView: trackersCollectionView) { [weak self] collectionView, indexPath, trackerItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath)
            guard let trackerCell = cell as? TrackerCollectionViewCell,
                  let trackerCellViewModel = self?.trackersViewModel.createTrackerCellViewModel(at: indexPath) else {
                return cell
            }
            
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
                  let dataSource = self?.trackersCollectionViewDataSource else {
                return supplementaryView
            }
            
            let snapshot = dataSource.snapshot()
            let category = snapshot.sectionIdentifiers[indexPath.section]
            
            switch category {
            case .section(let title):
                headerView.setupHeaderView(category: title)
            }
            
            return headerView
        }
    }
    
    private func bind() {
        trackersViewModel.onVisibleCategoriesChange = { [weak self] categories in
            self?.applySnapshot(categories)
        }
    }
    
    private func applySnapshot(_ categories: [TrackerCategory]) {
        guard let trackersCollectionViewDataSource else { return }
        
        var snapshot = Snapshot()
        for category in categories {
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
        let updatedDate = Calendar.current.startOfDay(for: datePicker.date)
        trackersViewModel.didUpdate(date: updatedDate)
    }
    
    @objc private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
        searchController.dismiss(animated: true)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        let calendar = Calendar.current
        var updatedDate = Calendar.current.startOfDay(for: datePicker.date)
        
        if gesture.direction == .left {
            updatedDate = calendar.date(byAdding: .day, value: 1, to: updatedDate) ?? updatedDate
        } else if gesture.direction == .right {
            updatedDate = calendar.date(byAdding: .day, value: -1, to: updatedDate) ?? updatedDate
        }
        
        datePicker.setDate(updatedDate, animated: true)
        trackersViewModel.didUpdate(date: updatedDate)
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, 
                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let indexPath = indexPaths.first,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else { return nil }
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                self?.createPreviewController(for: cell)
            },
            actionProvider: { [weak self] _ in
                guard let self else { return nil }
                let actions = createContextMenuActions(for: cell, at: indexPath)
                return UIMenu(children: actions)
            }
        )
    }

    private func createPreviewController(for cell: TrackerCollectionViewCell) -> UIViewController? {
        guard let previewView = cell.trackerCardView.snapshotView(afterScreenUpdates: true) else { return nil }

        let previewController = UIViewController()
        previewController.view.addSubview(previewView)

        previewController.preferredContentSize = previewView.bounds.size
        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: previewController.view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: previewController.view.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: previewController.view.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: previewController.view.bottomAnchor)
        ])

        return previewController
    }

    private func createContextMenuActions(for cell: TrackerCollectionViewCell, at indexPath: IndexPath) -> [UIAction] {
        let snapshot = trackersCollectionViewDataSource?.snapshot()
        let section = snapshot?.sectionIdentifiers[indexPath.section]
        let isPinned = section == .section(title: Constants.pinnedCategoryTitle)
        
        let pinActionTitle = isPinned ? "Открепить" : "Закрепить"
        let pinAction = UIAction(title: pinActionTitle) { [weak self] _ in
            if isPinned {
                self?.trackersViewModel.didUnpinTracker(at: indexPath)
            } else {
                self?.trackersViewModel.didPinTracker(at: indexPath)
            }
        }
        
        let editAction = UIAction(title: "Редактировать") { [weak self] _ in
            guard let self else { return }
            
            let trackerEditingViewModel = trackersViewModel.createTrackerEditingViewModel(at: indexPath)
            let trackerEditingViewController = TrackerEditingViewController(title: "Редактирование привычки", viewModel: trackerEditingViewModel)
            present(trackerEditingViewController, animated: true)
        }
        
        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            self?.trackersViewModel.didDeleteTracker(at: indexPath)
        }
        
        return [pinAction, editAction, deleteAction]
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        trackersViewModel.didUpdate(searchText: searchText)
    }
}
