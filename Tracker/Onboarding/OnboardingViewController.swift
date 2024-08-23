//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Александра Коснырева on 23.08.2024.
//

import Foundation
import UIKit
final class OnboardingViewController: UIPageViewController {
    var onEnterButtonTapped: (() -> Void)?
    lazy var pages: [UIViewController] = {
       
        let blueVC = UIViewController()
        let background1: UIImageView = {
            let background1 = UIImageView(image: UIImage(named: "background1"))
            return background1
        }()
        blueVC.view.addSubview(background1)
        NSLayoutConstraint.activate([
            background1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            background1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background1.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        let redVC = UIViewController()
        let backgrond2: UIImageView = {
            let backgrond2 = UIImageView(image: UIImage(named: "backgrond2"))
            return backgrond2
        }()
        redVC.view.addSubview(backgrond2)
        NSLayoutConstraint.activate([
            backgrond2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgrond2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgrond2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgrond2.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        return [blueVC, redVC]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
}


