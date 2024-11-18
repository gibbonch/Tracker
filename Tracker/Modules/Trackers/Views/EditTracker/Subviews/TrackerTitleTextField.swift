//
//  TrackerTitleTextField.swift
//  Tracker
//
//  Created by Александр Торопов on 10.11.2024.
//

import UIKit

protocol TrackerTitleTextFieldDelegate: AnyObject {
    func didEndEditing(_ textField: TrackerTitleTextField)
    func didCharacterLimitExceeded()
}

final class TrackerTitleTextField: UITextField {
    
    // MARK: - Properties
    
    private weak var trackerTitleTextFieldDelegate: TrackerTitleTextFieldDelegate?
    private let symbolsLimit = 38
    
    // MARK: - Content Size
    
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        return CGSize(width: defaultSize.width, height: 75)
    }
    
    // MARK: - Initializer
    
    init(trackerTitleTextFieldDelegate: TrackerTitleTextFieldDelegate) {
        self.trackerTitleTextFieldDelegate = trackerTitleTextFieldDelegate
        super.init(frame: .zero)
        delegate = self
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupTextField() {
        placeholder = "Введите название трекера"
        font = .ypRegular17
        backgroundColor = .lightGrayApp.withAlphaComponent(0.3)
        layer.cornerRadius = 16
        clearButtonMode = .whileEditing
        translatesAutoresizingMaskIntoConstraints = false
        addPadding()
    }
    
    private func addPadding() {
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        leftView = leftPadding
        leftViewMode = .always
        
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        rightView = rightPadding
        rightViewMode = .unlessEditing
    }
    
}

// MARK: - UITextFieldDelegate

extension TrackerTitleTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedLength = currentText.count + string.count - range.length
        if updatedLength <= 38 {
            return true
        } else {
            trackerTitleTextFieldDelegate?.didCharacterLimitExceeded()
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackerTitleTextFieldDelegate?.didEndEditing(self)
    }
    
}
