//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

// MARK: - Protocol Definition

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func addTracker(_ tracker: Tracker, to categoryTitle: String)
    func willDisappear()
}

// MARK: - CreateTrackerViewController

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .ypMedium16
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var regularEventButton = FilledButton(title: "Привычка") { [weak self] in
        let configureViewController = EditTrackerViewController(title: "Новая привычка", trackerType: .regular)
        configureViewController.delegate = self
        self?.present(configureViewController, animated: true)
    }
    private lazy var singleEventButton = FilledButton(title: "Нерегулярное событие") { [weak self] in
        let configureViewController = EditTrackerViewController(title: "Новое нерегулярное событие", trackerType: .single)
        configureViewController.delegate = self
        self?.present(configureViewController, animated: true)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.willDisappear()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(titleLabel, buttonStack)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - NewTrackerViewControllerDelegate

extension CreateTrackerViewController: EditTrackerViewControllerDelegate {
    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        delegate?.addTracker(tracker, to: categoryTitle)
    }
}
