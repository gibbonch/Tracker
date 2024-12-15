//
//  DefaultTrackerEditingViewModelDelegate.swift
//  Tracker
//
//  Created by Александр Торопов on 14.12.2024.
//

import Foundation

protocol DefaultTrackerEditingViewModelDelegate: AnyObject {
    func didUpdateCategory()
    func didUpdateSchedule()
    func didUpdateApplyButtonState()
    func didTitleExchangeLimit()
}
