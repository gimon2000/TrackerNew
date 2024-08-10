//
//  TrackersPresenterProtocol.swift
//  TrackerNew
//
//  Created by gimon on 30.06.2024.
//

import Foundation

protocol TrackersPresenterProtocol {
    var trackersViewController: TrackersViewControllerProtocol? { get set }
    
    func getCurrentDate() -> Date
    func setCurrentDate(date: Date)
    func getCountCategories() -> Int
    func getCountCategoriesInCurrentDate() -> Int
    func getCountTrackersInCategoriesInCurrentDate(inSection: Int) -> Int
    func getTrackersInDate(indexSection: Int, indexTracker: Int) -> Tracker?
    func setTracker(tracker: Tracker, category: String)
    func getNameCategory(index: Int) -> String    
    func setTrackerCompletedTrackers(id: UInt)
    func deleteTrackerCompletedTrackers(id: UInt)
    func containTrackerCompletedTrackers(id: UInt) -> Bool
    func countTrackerCompletedTrackers(id: UInt) -> String
}
