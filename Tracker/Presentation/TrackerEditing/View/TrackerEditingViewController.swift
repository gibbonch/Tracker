//
//  TrackerEditingViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 09.12.2024.
//

import UIKit

final class TrackerEditingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: TrackerEditingViewModel
    
    private let trackerTitleTextFieldDelegate: TrackerTitleTextFieldDelegate
    
    private let categoryAndScheduleTableViewDelegate: CategoryAndScheduleTableViewDelegate
    private let categoryAndScheduleTableViewDataSource: CategoryAndScheduleTableViewDataSource
    
    private let emojiCollectionViewDataSource: EmojiCollectionViewDataSource
    private let emojiCollectionViewDelegate: EmojiCollectionViewDelegate
    
    private let colorCollectionViewDataSource: ColorCollectionViewDataSource
    private let colorCollectionViewDelegate: ColorCollectionViewDelegate
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteApp
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.header
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completionsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .blackApp
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(viewModel.completionsCount ?? 0) \(Utilities.dayWord(for: viewModel.completionsCount ?? 0))"
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = trackerTitleTextFieldDelegate
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.text = viewModel.title
        textField.placeholder = "Введите название трекера"
        textField.textColor = .blackApp
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        
        textField.backgroundColor = .lightGrayApp.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.rightViewMode = .unlessEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .redApp
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var warningLabelHeighConstraint: NSLayoutConstraint?
    
    private lazy var categoryAndScheduleTableView: UITableView = {
        let tableView = UITableView()
        categoryAndScheduleTableViewDelegate.parentViewController = self
        tableView.delegate = categoryAndScheduleTableViewDelegate
        tableView.dataSource = categoryAndScheduleTableViewDataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryAndScheduleCell")
        
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = emojiCollectionViewDataSource
        collectionView.delegate = emojiCollectionViewDelegate
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.register(PickerHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PickerHeaderReusableView.identifier)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = colorCollectionViewDataSource
        collectionView.delegate = colorCollectionViewDelegate
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.register(PickerHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PickerHeaderReusableView.identifier)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var applyButton = FilledButton(title: viewModel.applyButtonText, isEnabled: viewModel.isApplyButtonEnabled) { [weak self] in
        self?.viewModel.applyButtonDidTap()
        self?.dismiss(animated: true)
    }
    
    private lazy var dismissButton = UndoButton(title: "Отменить") { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.addArrangedSubview(dismissButton)
        stackView.addArrangedSubview(applyButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: TrackerEditingViewModel) {
        self.viewModel = viewModel
        
        trackerTitleTextFieldDelegate = TrackerTitleTextFieldDelegate(viewModel: viewModel)
        
        categoryAndScheduleTableViewDelegate = CategoryAndScheduleTableViewDelegate(viewModel: viewModel)
        categoryAndScheduleTableViewDataSource = CategoryAndScheduleTableViewDataSource(viewModel: viewModel)
        
        emojiCollectionViewDataSource = EmojiCollectionViewDataSource(viewModel: viewModel)
        emojiCollectionViewDelegate = EmojiCollectionViewDelegate(viewModel: viewModel)
        
        colorCollectionViewDataSource = ColorCollectionViewDataSource(viewModel: viewModel)
        colorCollectionViewDelegate = ColorCollectionViewDelegate(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
        
        guard let viewModel = viewModel as? DefaultTrackerEditingViewModel else { return }
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        addGestureRecognizer()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .whiteApp
        view.addSubviews(headerLabel, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(completionsCountLabel, titleTextField, warningLabel, categoryAndScheduleTableView, 
                                emojiCollectionView, colorCollectionView, buttonsStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            completionsCountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            completionsCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            completionsCountLabel.heightAnchor.constraint(equalToConstant: viewModel.completionsCount == nil ? 0 : 38),
            
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: completionsCountLabel.bottomAnchor, constant: viewModel.completionsCount == nil ? 0 : 48),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            warningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            
            categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: viewModel.trackerType == .regular ? 150 : 75),
            categoryAndScheduleTableView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 24),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCollectionView.topAnchor.constraint(equalTo: categoryAndScheduleTableView.bottomAnchor, constant: 32),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            buttonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        warningLabelHeighConstraint = warningLabel.heightAnchor.constraint(equalToConstant: 0)
        warningLabelHeighConstraint?.isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 24).isActive = true
    }
    
    private func addGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(gesture)
    }
    
    // MARK: - Objc Methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.title = textField.text ?? ""
    }
    
    @objc private func dismissKeyboard() {
        titleTextField.endEditing(true)
    }
}

// MARK: - DefaultTrackerEditingViewModelDelegate

extension TrackerEditingViewController: DefaultTrackerEditingViewModelDelegate {
    func didUpdateCategory() {
        let categoryIndexPath = IndexPath(row: 0, section: 0)
        categoryAndScheduleTableView.reloadRows(at: [categoryIndexPath], with: .none)
    }
    
    func didUpdateSchedule() {
        let scheduleIndexPath = IndexPath(row: 1, section: 0)
        categoryAndScheduleTableView.reloadRows(at: [scheduleIndexPath], with: .none)
    }
    
    func didUpdateApplyButtonState() {
        applyButton.isEnabled = viewModel.isApplyButtonEnabled
    }
    
    func didTitleExchangeLimit() {
        warningLabelHeighConstraint?.constant = 30
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
