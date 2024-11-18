//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 06.11.2024.
//

import UIKit

// MARK: - TrackersViewController

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private var trackersViewModel: TrackersViewModel?
    private var trackersCollectionViewManager: TrackersCollectionViewManager?
    
    // MARK: - Subviews
    
    private lazy var placeholderView = PlaceholderView()
    private lazy var trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var addTrackerBarButtonItem = UIBarButtonItem(image: .plus, style: .plain, target: self, action: #selector(addTrackerButtonTapped))
    private lazy var datePicker = UIDatePicker()
    private lazy var titleLabel = YPLabel(text: "Трекеры", font: .ypBold34)
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Поиск"
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupGestureRecognizer()
        setupView()
        
        trackersViewModel = TrackersViewModel()
        trackersCollectionViewManager = TrackersCollectionViewManager(collectionView: trackersCollectionView)
        trackersCollectionViewManager?.delegate = self
        
        updateTrackers()
    }
    
    // MARK: - Actions
    
    @objc private func addTrackerButtonTapped() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.delegate = self
        present(createTrackerViewController, animated: true)
    }
    
    @objc private func datePickerValueChanged() {
        let relevantCategories = trackersViewModel?.relevantCategories(filterText: searchBar.text, selectedDate: datePicker.date)
        trackersCollectionViewManager?.applySnapshot(for: relevantCategories, date: datePicker.date)
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
        animateHideSearchBarCancelButton()
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
        addTrackerBarButtonItem.tintColor = .blackApp
        navigationItem.leftBarButtonItem = addTrackerBarButtonItem
        
        datePicker.locale = Locale(identifier: "ru-RU")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateTrackers() {
        let categories = trackersViewModel?.relevantCategories(filterText: searchBar.text, selectedDate: datePicker.date)
        trackersCollectionViewManager?.applySnapshot(for: categories, date: datePicker.date)
    }
}

// MARK: - TrackersCollectionViewManagerDelegate

extension TrackersViewController: TrackersCollectionViewManagerDelegate {
    var selectedDate: Date { datePicker.date }
    
    func didUpdateItemCount(to count: Int) {
        let hasItems = count > 0
        updateVisibility(forItems: hasItems)
        if !hasItems {
            updatePlaceholder()
        }
    }
    
    func isTrackerCompleted(trackerId: UUID, on date: Date) -> Bool {
        trackersViewModel?.isTrackerCompleted(trackerId, on: date) ?? false
    }
    
    func didTapCheckButton(in cell: TrackerCollectionViewCell) {
        guard let indexPath = trackersCollectionView.indexPath(for: cell),
              let tracker = trackersCollectionViewManager?.tracker(for: indexPath),
              let isCompleted = trackersViewModel?.isTrackerCompleted(tracker.id, on: datePicker.date)
        else { return }
        
        if isCompleted {
            trackersViewModel?.uncheckTracker(tracker.id, on: datePicker.date)
        } else {
            trackersViewModel?.checkTracker(tracker.id, on: datePicker.date)
        }
    }
    
    func didDelete(tracker: Tracker) {
        trackersViewModel?.deleteTracker(tracker, from: "Важное")
    }
    
    private func updateVisibility(forItems hasItems: Bool) {
        placeholderView.isHidden = hasItems
        trackersCollectionView.isHidden = !hasItems
    }
    
    private func updatePlaceholder() {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            prepareTrackersPlaceholder()
        } else {
            prepareSearchPlaceholder()
        }
    }
    
    private func prepareTrackersPlaceholder() {
        placeholderView.imageView.image = .trackersPlaceholder
        placeholderView.messageLabel.text = "Что будем отслеживать?"
    }
    
    private func prepareSearchPlaceholder() {
        placeholderView.imageView.image = .searchPlaceholder
        placeholderView.messageLabel.text = "Ничего не найдено"
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let relevantCategories = trackersViewModel?.relevantCategories(filterText: searchBar.text, selectedDate: datePicker.date)
        trackersCollectionViewManager?.applySnapshot(for: relevantCategories, date: datePicker.date)
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
    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        trackersViewModel?.addTracker(tracker, to: categoryTitle)
    }
    
    func willDisappear() {
        updateTrackers()
    }
}
