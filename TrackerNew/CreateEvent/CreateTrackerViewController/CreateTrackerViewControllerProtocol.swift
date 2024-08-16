//
//  CreateTrackerViewControllerProtocol.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import Foundation

protocol CreateTrackerViewControllerProtocol: AnyObject {
    var createTrackerPresenter: CreateTrackerPresenterProtocol? { get set }
    var delegate: SelectTypeEventViewControllerDelegate? { get set }
    var trackersDelegate: TrackersViewControllerDelegate? { get set }
}
