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
        return
        [PageViewController(imageName: "background1", labelText: "Отслеживайте только то, что хотите"),
          PageViewController(imageName: "background2", labelText: "Даже если это не литры воды и йога")
        ]
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
    
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControllTapped(_:)), for: .valueChanged)
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        dataSource = self
        delegate = self
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(pageControl)
        view.addSubview(onEnterButton)
        NSLayoutConstraint.activate([
            onEnterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onEnterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onEnterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            onEnterButton.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.bottomAnchor.constraint(equalTo: onEnterButton.topAnchor, constant: 24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func pageControllTapped(_ sender: UIPageControl) {
        let currentIndex = pageControl.currentPage
        setViewControllers([pages[currentIndex]], direction: .forward, animated: true)
    }
    
    @objc func enterButtonTapped() {
       onEnterButtonTapped?()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let indexFirst = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previusIndex = indexFirst - 1
        guard previusIndex >= 0 else {
            return nil
        }
        return pages[previusIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let indexFirst = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = indexFirst + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = currentIndex
        }
    }
}
