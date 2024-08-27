//
//  PageViewControllers.swift
//  Tracker
//
//  Created by Александра Коснырева on 23.08.2024.
//

import Foundation
import UIKit
final class PageViewController: UIViewController {
    private let imageName: String
    private let labelText: String
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(named: "blackColor")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var onEnterButton: UIButton = {
        let button = UIButton()
        button.isHidden = false
        button.isEnabled = true
        button.backgroundColor = UIColor(named: "blackColor")
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named:"blackColor")
        button.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(imageName: String, labelText: String) {
        self.imageName = imageName
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        [imageView, label].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -320),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            onEnterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onEnterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onEnterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            onEnterButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func enterButtonTapped() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onboardingShow")
        let tabBarController = TabBarViewController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

