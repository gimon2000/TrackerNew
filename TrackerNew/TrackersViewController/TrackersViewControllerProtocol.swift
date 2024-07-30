//
//  TrackersViewControllerProtocol.swift
//  TrackerNew
//
//  Created by gimon on 30.06.2024.
//

import Foundation

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersPresenter: TrackersPresenterProtocol? { get set }
    func collectionViewReloadData()
}
