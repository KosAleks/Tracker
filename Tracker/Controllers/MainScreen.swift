//
//  MainScreen.swift
//  Tracker
//
//  Created by Александра Коснырева on 08.07.2024.
//

import Foundation
import UIKit

final class MainScreen: UIViewController, UISearchBarDelegate, MainScreenDelegate {
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
    private let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createNavigation()
        createStarImage()
        createLabel()
        updateUI()
        createCollectionView()
        createLineView()
    }
    
    //MARK: Methods for creating
    
    private func createCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.layer.cornerRadius = 16
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
        starImage = UIImageView(image: UIImage(named: "star")
        )
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
        view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints =  false
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
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        // TODO: func showTrackersAtDate()
        print("Пользователь выбрал дату: \(formattedDate)")
    }
    
    //MARK: methods
    
    func addTracker(_ tracker: Tracker, to categoryIndex: Int) {
        categories.append(TrackerCategory(title: title ?? "", arrayTrackers: [tracker]))
        visibleCategories = categories
        updateUI()
    }
    
    func addTrackerComplited(id: UUID, date: Date) {
        completedTrackers.contains(TrackerRecord(
            id: id,
            date: date))
    }
    
    private func switchToChoiceVC () {
        let choiceVC = ChoiceVC()
        choiceVC.delegate = self
        let navController = UINavigationController(rootViewController: choiceVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    func updateUI() {
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

extension MainScreen: UICollectionViewDataSource, UICollectionViewDelegate {
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
        let id = visibleCategories[indexPath.section].arrayTrackers[indexPath.row].id
        let completedDays = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        cell.delegate = self
        cell.setup()
        cell.configure(with: tracker, completedDays: completedDays, trackerIsCompleted: false, indexPath: indexPath)
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseIdentifier, for: indexPath) as! SupplementaryView
            let title = "Домашний уют"
            view.setTitle(title: title)
            return view
        case UICollectionView.elementKindSectionFooter:
            // handle footer case if needed
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseIdentifier, for: indexPath) as! SupplementaryView
            return view
        default:
            fatalError("Unexpected element kind")
        }
    }
}

extension MainScreen: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = section == 0 ? 42 : 34
        return CGSize(width: collectionView.frame.width, height: height)
    }

    
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(
        width: 167,
        height: 148
    )
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






