//
//  TabBarVC.swift
//  Tracker
//
//  Created by Александра Коснырева on 18.07.2024.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    private func createTabBar() {
        let trackerVC = UINavigationController(rootViewController: MainScreen())
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill")?.withRenderingMode(.alwaysTemplate),
            selectedImage: nil
        )
        
        let statisticsVC = UINavigationController(rootViewController: StatisticsViewController())
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill")?.withRenderingMode(.alwaysTemplate),
            selectedImage: nil
        )
        
        viewControllers = [trackerVC, statisticsVC]
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .systemGray
    }
}
