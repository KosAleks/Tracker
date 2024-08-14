//
//  BaseVCClass.swift
//  Tracker
//
//  Created by Александра Коснырева on 13.08.2024.
//

import Foundation
import UIKit

class BaseVCClass: UIViewController {
    let labelNewHabit = UILabel()
    let enterTrackerName = UITextField()
    let tableView = UITableView()
    let containerView = UIView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    var trackerName = String()
    
    let scrollView = UIScrollView()
    
    func createScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        UIKit.NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func createConteinerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        UIKit.NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
            ])
    }
    
    func createEnterTrackerName() {
        enterTrackerName.backgroundColor = UIColor(named: "greyColor")
        enterTrackerName.placeholder = "Введите название трекера"
        enterTrackerName.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(enterTrackerName)
        enterTrackerName.layer.cornerRadius = 16
        enterTrackerName.textColor = UIColor(named: "blackColor")
        enterTrackerName.characterLimit = 38
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: enterTrackerName.frame.height))
        enterTrackerName.leftView = leftPaddingView
        enterTrackerName.leftViewMode = .always
        UIKit.NSLayoutConstraint.activate([
            enterTrackerName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            enterTrackerName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            enterTrackerName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            enterTrackerName.heightAnchor.constraint(equalToConstant: 75)
            ])
    }
    
    func createTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: enterTrackerName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
  
    func setupButton(_ button: UIButton,
                         title: String,
                         titleColor: UIColor,
                         backgroundColor: UIColor?,
                         borderColor: UIColor?,
                         isEnabled: Bool,
                     isCancelButton: Bool) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 16
        if let borderColor = borderColor {
                button.layer.borderColor = borderColor.cgColor
                button.layer.borderWidth = 1
            }
        button.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
        var constraints = [
                button.widthAnchor.constraint(equalToConstant: 166),
                button.heightAnchor.constraint(equalToConstant: 60),
                button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -34)
        ]
        if isCancelButton {
            constraints.append(button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20))
        }
        else {
            constraints.append(button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20))
        }
        NSLayoutConstraint.activate(constraints)
    }

    
    func createNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    @objc func textChanged() {
        trackerName = enterTrackerName.text ?? ""
        if trackerName.isEmpty {
            createButton.isEnabled = false
        } else {
            createButtonChanged()
        }
    }
    
    func createButtonChanged() {
        createButton.backgroundColor = UIColor(named: "blackColor")
        createButton.isEnabled = true
    }
    
}
