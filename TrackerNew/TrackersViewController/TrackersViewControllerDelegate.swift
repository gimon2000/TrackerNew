//
//  TrackersViewControllerDelegate.swift
//  TrackerNew
//
//  Created by gimon on 30.06.2024.
//

import Foundation

protocol TrackersViewControllerDelegate: AnyObject {
    func setTracker(tracker: Tracker, category: String)
}
