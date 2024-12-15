//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

final class TrackerCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TrackerCreationViewControllerDelegate?
    private var viewModel: TrackerCreationViewModel?
    
    // MARK: - Subviews
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .ypMedium16
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var regularEventButton = FilledButton(title: "Привычка") { [weak self] in
        self?.viewModel?.updateTrackerType(.regular)
    }
    
    private lazy var singleEventButton = FilledButton(title: "Нерегулярное событие") { [weak self] in
        self?.viewModel?.updateTrackerType(.single)
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
    
    // MARK: - Initializer
    
    init(viewModel: TrackerCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        guard let viewModel = viewModel as? DefaultTrackerCreationViewModel else { return }
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.viewWillDismiss()
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
}

extension TrackerCreationViewController: DefaultTrackerCreationViewModelDelegate {
    func didUpdateTrackerType() {
        guard let editTrackerViewModel = viewModel?.createTrackerEditingViewModel() else { return }
        let trackerEditingViewController = TrackerEditingViewController(viewModel: editTrackerViewModel)
        present(trackerEditingViewController, animated: true)
    }
}
