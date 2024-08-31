//
//  TabBarController.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#fileID, #function, #line)
        
        let trackersViewController = TrackersViewController()
        let trackersPresenter = TrackersPresenter()
        trackersViewController.trackersPresenter = trackersPresenter
        trackersPresenter.trackersViewController = trackersViewController
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        let titleTrackers = NSLocalizedString(
            "tab.bar.title.trackers",
            comment: "Text displayed in title"
        )
        navigationController.tabBarItem = UITabBarItem(
            title: titleTrackers,
            image: UIImage(named: "TrackersImage"),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        let titleStatistic = NSLocalizedString(
            "tab.bar.title.statistic",
            comment: "Text displayed in title"
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: titleStatistic,
            image: UIImage(named: "StatisticImage"),
            selectedImage: nil
        )
        self.tabBar.tintColor = .ypBlue
        self.tabBar.backgroundColor = .ypWhite
        self.viewControllers = [navigationController, statisticViewController]
    }
}
