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
    func getCountTrackersInCategoriesInCurentDate() -> Int
    func getTrackersInDate(index: Int) -> Tracker?
    func setTracker(tracker: Tracker)
    func getNameCategory(index: Int) -> String    
    func setTrackerRecordDate(id: UInt)
    func deleteTrackerRecordDate(id: UInt)
    func containTrackerRecordDate(id: UInt) -> Bool
    func countTrackerRecordDate(id: UInt) -> String
}
