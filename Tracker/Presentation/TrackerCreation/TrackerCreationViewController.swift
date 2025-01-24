//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

final class TrackerCreationViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackerCreation.title", comment: "Text displayed as title")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var regularEventButton = FilledButton(title: NSLocalizedString("habit", comment: "Habit text")) { [weak self] in
        self?.presentTrackerEditingViewController(trackerType: .regular)
    }
    
    private lazy var singleEventButton = FilledButton(title: NSLocalizedString("irregularEvent", comment: "Irregular event text")) { [weak self] in
        self?.presentTrackerEditingViewController(trackerType: .single)
    }
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 16
        stack.addArrangedSubview(regularEventButton)
        stack.addArrangedSubview(singleEventButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(headerLabel, buttonStack)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func presentTrackerEditingViewController(trackerType: TrackerType) {
        let trackerStore = TrackerStore(coreDataStack: CoreDataStack.shared)
        let trackerEditingViewModel = DefaultTrackerEditingViewModel(trackerStore: trackerStore, trackerType: trackerType)
        let trackerEditingViewController = TrackerEditingViewController(
            title: trackerType == .regular ? NSLocalizedString("title.newTracker", comment: "New tracker title") : NSLocalizedString("title.newIrregularTracker", comment: "New irregular tracker title"),
            viewModel: trackerEditingViewModel)
        present(trackerEditingViewController, animated: true)
    }
}
