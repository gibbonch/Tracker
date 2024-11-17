//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Александр Торопов on 07.11.2024.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func newTrackerViewController(_ viewController: NewTrackerViewController, didCreateTracker tracker: Tracker, for category: String)
}

final class NewTrackerViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private lazy var categoryViewController = CategoryViewController(delegate: self)
    private lazy var scheduleViewController = ScheduleViewController(delegate: self)
    
    private let trackerType: TrackerType
    private var trackerTitle: String?
    private var trackerCategory: String?
    private var trackerSchedule: [Day]?
    private var trackerEmoji: String?
    private var trackerColor: UIColor?
    
    // MARK: - Subviews
    private lazy var titleLabel = YPLabel(text: trackerType == .regular ? "Новая привычка" : "Новое регулярное событие", font: .ypMedium16)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleTextField = TrackerTitleTextField(trackerTitleTextFieldDelegate: self)
    
    private lazy var warningLabel = YPLabel(text: "Ограничение 38 символов", font: .ypRegular17, textColor: .redApp)
    
    private var warningLabelHeighConstraint: NSLayoutConstraint?
    
    private lazy var parametersTableView = ParametersTableView(parametersTableViewDelegate: self, parameters: prepareParameters())
    
    private lazy var emojiLabel = YPLabel(text: "Emoji", font: .ypBold19)
    
    private lazy var emojiPickerCollection = PickerCollectionView<EmojiCollectionViewCell>(pickerCollectionViewDelegate: self)
    
    private lazy var colorLabel = YPLabel(text: "Цвет", font: .ypBold19)
    
    private lazy var colorPickerCollection = PickerCollectionView<ColorCollectionViewCell>(pickerCollectionViewDelegate: self)
    
    private lazy var saveButton = FilledButton(title: "Сохранить", isEnabled: false) { [weak self] in
        guard let self,
              let tracker = self.createTracker(),
              let trackerCategory = self.trackerCategory
        else { return }
        
        self.delegate?.newTrackerViewController(self, didCreateTracker: tracker, for: trackerCategory)
        self.dismiss(animated: true)
    }
    
    private lazy var undoButton = UndoButton(title: "Отменить") { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(undoButton)
        stackView.addArrangedSubview(saveButton)
        
        return stackView
    }()
    
    // MARK: - Initializers
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        if trackerType == .single {
            trackerSchedule = Day.allCases
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizer()
        setupView()
    }
    
    // MARK: -  Private Methods
    private func setupView() {
        view.backgroundColor = .whiteApp
        
        view.addSubviews(titleLabel, scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(titleTextField, warningLabel, parametersTableView)
        contentView.addSubviews(emojiLabel, emojiPickerCollection, colorLabel, colorPickerCollection, buttonStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            warningLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            warningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            
            parametersTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            parametersTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            parametersTableView.heightAnchor.constraint(equalToConstant: trackerType == .regular ? 150 : 75),
            parametersTableView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 24),
            
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: parametersTableView.bottomAnchor, constant: 32),
            
            emojiPickerCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiPickerCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiPickerCollection.heightAnchor.constraint(equalToConstant: 204),
            emojiPickerCollection.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            colorLabel.topAnchor.constraint(equalTo: emojiPickerCollection.bottomAnchor),
            
            colorPickerCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorPickerCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorPickerCollection.heightAnchor.constraint(equalToConstant: 204),
            colorPickerCollection.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonStackView.topAnchor.constraint(equalTo: colorPickerCollection.bottomAnchor, constant: 16),
        ])
        
        warningLabelHeighConstraint = warningLabel.heightAnchor.constraint(equalToConstant: 0)
        warningLabelHeighConstraint?.isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 24).isActive = true
    }
    
    private func createTracker() -> Tracker? {
        guard let trackerTitle = trackerTitle,
              let trackerCategory = trackerCategory,
              let trackerColorID = UIColor.identifier(for: trackerColor),
              let trackerEmoji = trackerEmoji,
              var trackerSchedule = trackerSchedule
        else { return nil }
        
        return Tracker(type: trackerType, title: trackerTitle, colorID: trackerColorID, emoji: trackerEmoji, schedule: trackerSchedule)
    }
    
    private func updateButtonAppearance() {
        guard let trackerTitle = trackerTitle, !trackerTitle.isEmpty,
              let trackerColor = trackerColor,
              let trackerColorId = UIColor.identifier(for: trackerColor), (1...18).contains(trackerColorId),
              let trackerEmoji = trackerEmoji, !trackerEmoji.isEmpty,
              let trackerCategory = trackerCategory, !trackerCategory.isEmpty,
              let trackerSchedule = trackerSchedule, !trackerSchedule.isEmpty
        else {
            saveButton.isEnabled = false
            return
        }
        
        saveButton.isEnabled = true
    }
}

// MARK: - Gesture Recognizer
extension NewTrackerViewController {
    
    private func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TrackerTitleTextFieldDelegate
extension NewTrackerViewController: TrackerTitleTextFieldDelegate {
    
    func didReachLimit() {
        warningLabelHeighConstraint?.constant = 30
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didEndEditing(_ textField: TrackerTitleTextField) {
        trackerTitle = textField.text
        updateButtonAppearance()
    }
}

// MARK: - ParametersTableViewDelegate
extension NewTrackerViewController: ParametersTableViewDelegate {
    
    func didSelectRow(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            present(categoryViewController, animated: true)
        } else {
            present(scheduleViewController, animated: true)
        }
    }
    
    private func prepareParameters() -> [Parameter] {
        var parameters = [Parameter]()
        
        let category = Parameter(title: "Категория", details: trackerCategory)
        parameters.append(category)
        
        if trackerType == .regular {
            let scheduleDetails = trackerSchedule?.count == 7 ? "Каждый день" : trackerSchedule?.map { $0.toShortString() }.joined(separator: ", ")
            let schedule = Parameter(title: "Расписание", details: scheduleDetails)
            parameters.append(schedule)
        }
        
        return parameters
    }
}

// MARK: - PickerCollectionViewDelegate
extension NewTrackerViewController: PickerCollectionViewDelegate {
    
    func pickerCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let colorCell = cell as? ColorCollectionViewCell {
            trackerColor = colorCell.colorView.backgroundColor
        } else if let emojiCell = cell as? EmojiCollectionViewCell {
            trackerEmoji = emojiCell.emojiLabel.text
        }
        updateButtonAppearance()
    }
}

// MARK: - ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    
    func didChangeSchedule(state: [Day]) {
        trackerSchedule = state
        parametersTableView.configure(with: prepareParameters())
        updateButtonAppearance()
    }
}

extension NewTrackerViewController: CategoryTableViewDelegate {
    
    func categoryTableView(_ tableView: UITableView, didSelectCategory category: String?) {
        trackerCategory = category
        parametersTableView.configure(with: prepareParameters())
        updateButtonAppearance()
    }
}
