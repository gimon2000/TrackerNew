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
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackersImage"),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticImage"),
            selectedImage: nil
        )
        self.tabBar.tintColor = .ypBlue
        self.viewControllers = [navigationController, statisticViewController]
    }
}
