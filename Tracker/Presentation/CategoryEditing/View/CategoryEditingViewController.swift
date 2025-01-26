//
//  CategoryEditingViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 17.01.2025.
//

import UIKit

final class CategoryEditingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: CategoryEditingViewModel
    
    // MARK: - Subviews
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.headerTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackApp
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.text = viewModel.title
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.placeholder = NSLocalizedString("categoryTitle.placeholder", comment: "Text displayed on text field as a placeholder")
        textField.textAlignment = Utilities.isCurrentLanguageRTL() ? .right : .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var acceptButton: FilledButton = {
        let button = FilledButton(title: NSLocalizedString("done", comment: "Done actino text"), isEnabled: viewModel.isCategoryCreationAllowed) { [weak self] in
            self?.viewModel.createCategory { [weak self] in
                self?.dismiss(animated: true)
            }
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    init(viewModel: CategoryEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        setupBinding()
        addGestureRecognizer()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubview(headerLabel)
        view.addSubview(titleTextField)
        view.addSubview(acceptButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            acceptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            acceptButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupBinding() {
        viewModel.onTitleChangeState = { [weak self] title in
            self?.acceptButton.isEnabled = !title.isEmpty
        }
    }
    
    private func addGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - Objc Methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.titleDidChange(textField.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
