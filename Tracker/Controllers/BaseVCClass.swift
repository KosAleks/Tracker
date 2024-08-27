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
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    let cancelButton = UIButton()
    let createButton = UIButton()
    var trackerName = String()
    let scrollView = UIScrollView()
    let collectionViewForHabitVC: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            NewTrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: NewTrackerCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            NewTrackerSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewTrackerSupplementaryView.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    //MARK: Methods for setup UI
    
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
    
    func setupCollectionViewForHabitVC() {
        containerView.addSubview(collectionViewForHabitVC)
        collectionViewForHabitVC.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionViewForHabitVC.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionViewForHabitVC.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            collectionViewForHabitVC.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            collectionViewForHabitVC.heightAnchor.constraint(equalToConstant: 476)
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
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func createEnterTrackerName() {
        enterTrackerName.backgroundColor = Constants.greyColor
        enterTrackerName.placeholder = "Введите название трекера"
        enterTrackerName.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(enterTrackerName)
        enterTrackerName.layer.cornerRadius = 16
        enterTrackerName.textColor = Constants.blackColor
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
    
    func createTableViewForHabit() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: enterTrackerName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func createTableViewForIrregularEvent() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: enterTrackerName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func setupButton(_ button: UIButton,
                     title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor?,
                     borderColor: UIColor?,
                     isEnabled: Bool,
                     isCancelButton: Bool
    ) {
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
    }
    
    func setupButtonStack() {
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(buttonStackView)
        buttonStackView.topAnchor.constraint(equalTo: collectionViewForHabitVC.bottomAnchor, constant: 16).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
    }
    
    //MARK: Methods
    
    func createNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func createButtonChanged() {
        createButton.backgroundColor = Constants.blackColor
        createButton.isEnabled = true
    }
    
    //MARK: @objc methods
    
   
}
