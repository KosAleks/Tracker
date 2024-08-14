//
//  MainScreen.swift
//  Tracker
//
//  Created by Александра Коснырева on 08.07.2024.
//

import Foundation
import UIKit

final class MainScreen: UIViewController, UISearchBarDelegate {
    private var starImage = UIImageView()
    private let whatWillTrack = UILabel()
   
    private var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CollectionCellTracker.self, forCellWithReuseIdentifier: CollectionCellTracker.reuseIdentifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.reuseIdentifier)
        return collectionView
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    private let searchBar: UISearchController = {
        let searchBar = UISearchController()
        return searchBar
    }()
    
    private let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(named: "darkGrey")
        return lineView
    }()
    
    private var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    
    private var completedTrackers: Set<TrackerRecord> = [] //Трекеры, которые были «выполнены» в выбранную дату
    private var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createNavigation()
        createStarImage()
        createLabel()
        createCollectionView()
        createLineView()
        updateUI()
    }
    
    //MARK: Methods for creating
    
    private func createCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func createNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(leftButtonTapped))
        navigationItem.leftBarButtonItem = addButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        datePicker.addTarget(
            self,
            action: #selector(datePickerChanged),
            for: .valueChanged
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.searchController = searchBar
    }
    
    private func createStarImage() {
        starImage = UIImageView(image: UIImage(named: "star"))
        starImage.contentMode = .scaleAspectFit
        starImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(starImage)
        starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        starImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func createLabel() {
        whatWillTrack.contentMode = .scaleAspectFit
        whatWillTrack.translatesAutoresizingMaskIntoConstraints = false
        whatWillTrack.text = "Что будем отслеживать?"
        whatWillTrack.font = UIFont(name: "SFPro-Medium", size: 12)
        whatWillTrack.textColor = UIColor(named: "blackColor")
        self.view.addSubview(whatWillTrack)
        
        whatWillTrack.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 10).isActive = true
        whatWillTrack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func createLineView() {
        lineView.translatesAutoresizingMaskIntoConstraints =  false
        self.view.addSubview(lineView)
        lineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84) .isActive = true
        lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    //MARK: @objc methods
    
    @objc func leftButtonTapped() {
        switchToChoiceVC()
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        filteredTrackers()
        updateUI()
    }
    
    private func filteredTrackers() {
        let calendar = Calendar.current
        let selectedDate = calendar.component(.day, from: datePicker.date)
        let selectedDateString = String(selectedDate)
        // получили выбранную дату на которую тыкнули
        //нужно проверить есть ли в выбранную дату какие-то нерегулярные события
        print("\(selectedDate)")
        let selectedWeekDay = calendar.component(.weekday, from: currentDate) - 1
        let selectedDayString = WeekDay(rawValue: selectedWeekDay)?.stringValue ?? ""
        
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.arrayTrackers.filter {
                tracker in
                return tracker.schedule.contains(selectedDayString)
            }
            return !filteredTrackers.isEmpty ? TrackerCategory(title: category.title, arrayTrackers: filteredTrackers) : nil
        }
            collectionView.reloadData()
    }
    
    //MARK: methods
    
    func addTracker(_ tracker: Tracker, to categoryIndex: Int) {
        if categoryIndex < categories.count {
            categories[categoryIndex].arrayTrackers.append(tracker)
        } else {
            let newCategory = TrackerCategory(title: "Новая категория", arrayTrackers: [tracker])
            categories.append(newCategory)
        }
        visibleCategories = categories
        updateUI()
    }

    private func switchToChoiceVC () {
        let choiceVC = ChoiceVC()
        choiceVC.delegate = self
        let navController = UINavigationController(rootViewController: choiceVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    private func updateUI() {
        if visibleCategories.isEmpty {
            collectionView.isHidden = true
        } else {
            starImage.isHidden = true
            whatWillTrack.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    func didCreateNewTracker(title: String, tracker: Tracker) {
        addTracker(tracker, to: 0)
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDay
    }
}

//MARK: Settings UINavigationController

let mainVC = MainScreen()
let navigationController = UINavigationController(rootViewController: mainVC)

//MARK: Extensions

extension MainScreen: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].arrayTrackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellTracker.reuseIdentifier, for: indexPath) as? CollectionCellTracker else {
            assertionFailure("Something goinng wronng with custom cell creation.")
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        _ = visibleCategories[indexPath.section].arrayTrackers[indexPath.row].id
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        cell.configure(with: tracker, completedDays: completedDays, trackerIsCompleted: isCompletedToday, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = SupplementaryView.reuseIdentifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as? SupplementaryView else {
            fatalError("Unexpected view type")
        }
        
        let category = visibleCategories[indexPath.section]
        let title = (category.title.isEmpty == false) ? category.title : "Новая категория"
        
        view.setTitle(title: title)
        return view
    }
}


extension MainScreen: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        var height = CGFloat()
        if section == 0 {
            height = 42
        } else {
            height = 34
        }
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (collectionView.bounds.width) / 2 - 9,
            height: 148
        )
    }
}

extension MainScreen: TrackerCollectionCellDelegate {
    func record(_ sender: Bool, _ cell: CollectionCellTracker) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let id = visibleCategories[indexPath.section].arrayTrackers[indexPath.row].id
        let newRecord = TrackerRecord(id: id, date: currentDate)
        
        switch sender {
        case true:
            completedTrackers.insert(newRecord)
        case false:
            completedTrackers.remove(newRecord)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if currentDate <= Date() {
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
            completedTrackers.insert(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers = completedTrackers.filter { trackerRecord in
            !isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

extension MainScreen: NewTrackerViewControllerDelegate {
    
    func setDateForNewTracker() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: currentDate)
    }
    
    func didCreateNewTracker(_ tracker: Tracker) {
        addTracker(tracker, to: 0)
    }
}





