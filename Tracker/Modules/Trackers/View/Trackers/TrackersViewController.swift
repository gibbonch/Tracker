//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    private var trackersViewModel: TrackersViewModel?
    private var dataSourceProvider: TrackerDataSourceProvider?
    
    // MARK: - Subviews
    private lazy var placeholderView = PlaceholderView()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeader.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var addTrackerBarButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: .plus, style: .plain, target: self, action: #selector(addTrackerButtonTapped))
        buttonItem.tintColor = .blackApp
        return buttonItem
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru-RU")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .ypBold34
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Поиск"
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: - Initializer
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        trackersViewModel = TrackersViewModel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupGestureRecognizer()
        setupView()
        
        trackersViewModel = TrackersViewModel()
        dataSourceProvider = TrackerDataSourceProvider(collectionView: trackersCollectionView)
        dataSourceProvider?.delegate = self
        
        updateTrackers()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(titleLabel, searchBar, trackersCollectionView, placeholderView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = addTrackerBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func updateTrackers() {
        let relevantCategories = trackersViewModel?.relevantCategories(filterText: searchBar.text, selectedDate: datePicker.date)
        dataSourceProvider?.applySnapshot(for: relevantCategories, date: datePicker.date)
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    @objc private func addTrackerButtonTapped() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.trackersViewModel = trackersViewModel
        createTrackerViewController.delegate = self
        present(createTrackerViewController, animated: true)
    }
    
    @objc private func datePickerValueChanged() {
        let relevantCategories = trackersViewModel?.relevantCategories(filterText: searchBar.text, selectedDate: datePicker.date)
        dataSourceProvider?.applySnapshot(for: relevantCategories, date: datePicker.date)
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
        animateHideSearchBarCancelButton()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - CGFloat(9 + 16 * 2)
        let cellWidth = availableWidth / CGFloat(2)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - TrackersDataSourceProviderDelegate
extension TrackersViewController: TrackersDataSourceProviderDelegate {
    
    func didUpdateItemCount(to count: Int) {
        if count > 0 {
            placeholderView.isHidden = true
            trackersCollectionView.isHidden = false
        } else {
            if searchBar.text != "" {
                placeholderView.imageView.image = .searchPlaceholder
                placeholderView.messageLabel.text = "Ничего не найдено"
            } else {
                placeholderView.imageView.image = .trackersPlaceholder
                placeholderView.messageLabel.text = "Что будем отслеживать?"
            }
            placeholderView.isHidden = false
            trackersCollectionView.isHidden = true
        }
    }
    
    func isTrackerCompleted(for trackerId: UUID, on date: Date) -> Bool {
        trackersViewModel?.isTrackerCompleted(trackerId, on: date) ?? false
    }
}

// MARK: - TrackerCollectionViewCellDelegate
extension TrackersViewController: TrackerCollectionViewCellDelegate {
    
    func didTapCheckButton(in cell: TrackerCollectionViewCell) {
        guard let indexPath = trackersCollectionView.indexPath(for: cell),
              let tracker = dataSourceProvider?.tracker(for: indexPath) else { return }
        
        let isCompleted = trackersViewModel?.isTrackerCompleted(tracker.id, on: datePicker.date) ?? false
        if isCompleted {
            trackersViewModel?.uncheckTracker(tracker.id, on: datePicker.date)
        } else {
            trackersViewModel?.checkTracker(tracker.id, on: datePicker.date)
        }
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let relevantCategories = trackersViewModel?.relevantCategories(filterText: searchBar.text, selectedDate: datePicker.date)
        dataSourceProvider?.applySnapshot(for: relevantCategories, date: datePicker.date)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setValue("Отменить", forKey: "cancelButtonText")
        animateShowSearchBarCancelButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        animateHideSearchBarCancelButton()
    }
    
    private func animateShowSearchBarCancelButton() {
        UIView.animate(withDuration: 0.3) {
            self.searchBar.setShowsCancelButton(true, animated: true)
        }
    }
    
    private func animateHideSearchBarCancelButton() {
        UIView.animate(withDuration: 0.3) {
            self.searchBar.setShowsCancelButton(false, animated: true)
        }
    }
}

// MARK: - CreateTrackerViewControllerDelegate

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    
    func createTrackerViewControllerDidDismiss() {
       updateTrackers()
    }
}
