//
//  TrackerEditingViewController+UITextFieldDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 10.12.2024.
//

import UIKit

final class TrackerTitleTextFieldDelegate: NSObject, UITextFieldDelegate {
    private weak var viewModel: TrackerEditingViewModel?
    
    init(viewModel: TrackerEditingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedLength = currentText.count + string.count - range.length
        if updatedLength <= 38 {
            return true
        } else {
            viewModel?.presentWarningMessage()
            return false
        }
    }
}
