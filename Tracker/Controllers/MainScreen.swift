//
//  MainScreen.swift
//  Tracker
//
//  Created by Александра Коснырева on 08.07.2024.
//

import Foundation
import UIKit

final class MainScreen : UITabBarController, UISearchBarDelegate {
    private var starImage = UIImageView()
    private let whatWillTrack = UILabel()
    private let buttonPlus = UIButton()
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionnCell")
        return collectionView
    }()
    private let datePicker = UIDatePicker()
    private let navBarItem = UINavigationItem()
    private let trackerVC = TrackersViewController()
    
    private var categories = [TrackerCategory(title: "Домашние дела", arrayTrackers: [Tracker(
        id: UUID(),
        name: "Прогулка с собакой",
        color: UIColor(named: "6") ?? .systemPink,
        emoji: "🐶",
        schedule: [true, true, true, false, false, false, false])]),
                              TrackerCategory(title: "Спорт", arrayTrackers: [Tracker(
                                id: UUID(),
                                name: "Игра в теннис",
                                color: UIColor(named: "5") ?? .green,
                                emoji: "🏓",
                                schedule: [false, true, false, true, false, false, false])]),
                              TrackerCategory(title: "Музыка", arrayTrackers: [Tracker(
                                id: UUID(),
                                name: "Игра на гитаре",
                                color: UIColor(named: "14") ?? .blue,
                                emoji: "🎸",
                                schedule: [true, false, true, false, true, false, false])])
    ]
    private var visibleCategories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = [] //Трекеры, которые были «выполнены» в выбранную дату
    private let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStarImage()
        createLabel()
        createTabBar()
        createNavigation()
        checkExistingTrackers()
    }
    
    //MARK: Methods for creating
    
    private func createTabBar() {
        let trackerVC = TrackersViewController()
        trackerVC.view.backgroundColor = UIColor(named: "whiteColor")
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "record.circle.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.view.backgroundColor = UIColor(named: "whiteColor")
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "hare.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        self.viewControllers = [trackerVC, statisticsVC]
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func createNavigation() {
        
        title = " "
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Настройка левой кнопки
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(leftButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = UIColor(named: "blackColor")
        // Настройка Date Picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        navBarItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        let dateBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = dateBarButtonItem
        
        // Настройка поисковой строки
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        
        // Настройка Stack View для заголовка и поисковой строки
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(searchBar)
        
        view.addSubview(stackView)
        
        // Установка констрейнтов для Stack View
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func createStarImage() {
        starImage = UIImageView(image: UIImage(named: "star")
        )
        starImage.contentMode = .scaleAspectFit
        starImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(starImage)
        starImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 358) .isActive = true
        starImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 147).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        starImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -147).isActive = true
    }
    
    private func createLabel() {
        whatWillTrack.contentMode = .scaleAspectFit
        whatWillTrack.translatesAutoresizingMaskIntoConstraints = false
        whatWillTrack.text = "Что будем отслеживать?"
        whatWillTrack.font = .systemFont(ofSize: 12)
        whatWillTrack.textColor = UIColor(named: "blackColor")
        self.view.addSubview(whatWillTrack)
        
        whatWillTrack.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8).isActive = true
        whatWillTrack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: @objc metods
    
    @objc func leftButtonTapped() {
        switchToChoiceVC()
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        // TODO: func showTrackersAtDate()
        print("Выбранная дата: \(formattedDate)")
    }
    
    //MARK: Implementation of screen logic
    
    func addNewTracker(title: String, tracker: Tracker) {
        var newCategories: [TrackerCategory] = []
        var categoryExists = false
        for category in categories {
            if category.title == title {
                // Категория существует, добавляем трекер в эту категорию
                var updatedCategory = category
                updatedCategory.arrayTrackers.append(tracker)
                newCategories.append(updatedCategory)
                categoryExists = true
            } else {
                // Категория не совпадает, добавляем её в новый массив
                newCategories.append(category)
            }
        }
        if categoryExists == false {
            // если категория с нужным заголовком не найдена создаю новую категорию
            let newCategory = TrackerCategory(title: title, arrayTrackers: [tracker])
            newCategories.append(newCategory)
        }
        categories = newCategories
    }
    
    func addTrackerComplited(id: UUID, date: Date) {
        completedTrackers.append(TrackerRecord(
            id: id,
            date: date))
    }
    
    private func switchToChoiceVC () {
        let choiceVC = ChoiceVC()
        let navController = UINavigationController(rootViewController: choiceVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    private func checkExistingTrackers() {
        if visibleCategories.isEmpty {
            collectionView.isHidden = true
        } else {
            starImage.isHidden = true
            whatWillTrack.isHidden = true
            collectionView.isHidden = false
        }
    }
}

//MARK: Settings UINavigationController

let mainVC = MainScreen()
let navigationController = UINavigationController(rootViewController: mainVC)






