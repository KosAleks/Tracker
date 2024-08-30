//
//  MainScreen.swift
//  Tracker
//
//  Created by Александра Коснырева on 08.07.2024.
//

import Foundation
import UIKit

final class MainScreen: UIViewController, UISearchBarDelegate {
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var trackers = [Tracker]()
    private var starImage = UIImageView()
    private let whatWillTrack = UILabel()
    private let analyticsService = AnalyticsService()
    private var currentFilter: TrackerFilter = .all
    private var originalCategories: [UUID: String] = [:]
    private let colors = Colors()
    
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
        lineView.backgroundColor = Constants.darkGrey
        return lineView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Filters", comment: "Title for the filter button"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Constants.blue
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let placeholderImageFilter: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "filterHolder")
        return image
    }()
    
    private let placeholderLabelFilter: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    
    private var completedTrackers: Set<TrackerRecord> = [] //Трекеры, которые были «выполнены» в выбранную дату
    private var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.viewBackgroundColor
        createNavigation()
        createStarImage()
        createLabel()
        createCollectionView()
        createLineView()
        createFilterButton()
        syncData()
        updateUI()
        hideKeyboardWhenTappedAround()
        deleteAllTrackers(for: ["Закрепленные"])
    }
    
    private func deleteAllTrackers(for categoryNames: [String]) {
        let categoriesToDelete = categoryNames.compactMap { trackerCategoryStore.category(with: $0) }
        if categoriesToDelete.isEmpty {
            print("No categories found to delete")
            return
        }
        do {
            for category in categoriesToDelete {
                try trackerCategoryStore.deleteCategory(category)
            }
            collectionView.reloadData()
            updateUI()
        } catch {
            print("Ошибка при удалении трекеров или категорий: \(error)")
        }
    }
    
    //MARK: Methods for setup UI
    
    private func createCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -tabBarController!.tabBar.frame.height/50).isActive = true
        let filterButtonHeight: CGFloat = 50
        let filterButtonBottomInset: CGFloat = 16
        let collectionViewBottomInset = filterButtonHeight + filterButtonBottomInset + 16
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: collectionViewBottomInset, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    private func createNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("Trackers", comment: "Title for the main screen")
        navigationController?.navigationBar.tintColor = colors.navigationBarTintColor
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(leftButtonTapped))
        navigationItem.leftBarButtonItem = addButton
        navigationItem.leftBarButtonItem?.tintColor = Colors.ypBlack
        
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
        whatWillTrack.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        whatWillTrack.textColor = Colors.ypBlack
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
    
    private func  createFilterButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 115).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: Methods
    
    private func filteredTrackers() {
        let calendar = Calendar.current
        let selectedDate = calendar.component(.day, from: datePicker.date)
        let selectedDateString = String(selectedDate)
        let selectedWeekDay = calendar.component(.weekday, from: currentDate) - 1
        let selectedDayString = WeekDay(rawValue: selectedWeekDay)?.stringValue ?? ""
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.arrayTrackers.filter { tracker in
                let matchesDayOfWeek = tracker.schedule.contains(selectedDayString)
                let matchesDate = tracker.schedule.contains(selectedDateString)
                
                return matchesDayOfWeek || matchesDate
            }
            return !filteredTrackers.isEmpty ? TrackerCategory(title: category.title, arrayTrackers: filteredTrackers) : nil
        }
        
        collectionView.reloadData()
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        do {
            if let categoryIndex = categories.firstIndex(where: { $0.title == category.title }) {
                categories[categoryIndex].arrayTrackers.append(tracker)
            } else {
                let newCategory = TrackerCategory(
                    title: category.title,
                    arrayTrackers: [tracker])
                categories.append(newCategory)
            }
            visibleCategories = categories
            
            if try trackerCategoryStore.fetchCategories().filter({$0.title == category.title}).count == 0 {
                let newCategoryCoreData = TrackerCategory(title: category.title, arrayTrackers: [])
                try trackerCategoryStore.addNewCategory(newCategoryCoreData)
            }
            
            createCategoryAndTracker(tracker: tracker, with: category.title)
            fetchCategory()
            collectionView.reloadData()
            updateUI()
        } catch {
            print("Error: \(error)")
        }
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
            starImage.isHidden = false
            whatWillTrack.isHidden = false
            placeholderImageFilter.isHidden = true
            placeholderLabelFilter.isHidden = true
            filterButton.isHidden = true
        } else {
            starImage.isHidden = true
            whatWillTrack.isHidden = true
            collectionView.isHidden = false
            placeholderImageFilter.isHidden = true
            placeholderLabelFilter.isHidden = true
            filterButton.isHidden = false
            collectionView.reloadData()
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDay
    }
    
    
    private func syncData() {
        trackerCategoryStore.delegate = self
        trackerStore.delegate = self
        fetchCategory()
        fetchRecord()
        if !categories.isEmpty {
            visibleCategories = categories
            collectionView.reloadData()
        }
        
        updateUI()
    }
    
    private func loadTrackersAndCategories() {
        do {
            let trackerCategoriesCoreData = try trackerCategoryStore.fetchCategories()
            var trackerCategories = trackerCategoriesCoreData.compactMap { trackerCategoryStore.updateTrackerCategory($0) }
            
            if let pinnedIndex = trackerCategories.firstIndex(where: { $0.title == "Закрепленные" }) {
                let pinnedCategory = trackerCategories.remove(at: pinnedIndex)
                trackerCategories.insert(pinnedCategory, at: 0)
            }
            
            categories = trackerCategories
            visibleCategories = trackerCategories.filter { !$0.arrayTrackers.isEmpty }
            collectionView.reloadData()
            updateUI()
        } catch {
            print("Failed to load trackers and categories: \(error)")
        }
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
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "filter"])
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        filterViewController.selectedFilter = currentFilter
        let filterNavController = UINavigationController(rootViewController: filterViewController)
        self.present(filterNavController, animated: true)
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
            assertionFailure("Something goinng wrong with custom cell creation.")
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
            createRecord(record: trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        if let trackerRecordToDelete = completedTrackers.first(where: { $0.id == id }) {
            completedTrackers.remove(trackerRecordToDelete)
            deleteRecord(record: trackerRecordToDelete)
            
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func pinTracker(at indexPath: IndexPath) {
        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        let currentCategory = visibleCategories[indexPath.section].title
        
        if currentCategory == "Закрепленные" {
            unpinTracker(at: indexPath)
        } else {
            pinTracker(tracker, from: currentCategory)
        }
        
        fetchCategoryAndUpdateUI()
        loadTrackersAndCategories()
    }
    
    func unpinTracker(at indexPath: IndexPath) {
        let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: "Закрепленные")
        if let originalCategory = originalCategories[tracker.id] {
            try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: originalCategory)
            originalCategories.removeValue(forKey: tracker.id)
        }
        
        fetchCategoryAndUpdateUI()
        loadTrackersAndCategories()
    }
    
    private func pinTracker(_ tracker: Tracker, from category: String) {
        ensurePinnedCategoryExists()
        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: category)
        originalCategories[tracker.id] = category
        try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: "Закрепленные")
        
        fetchCategoryAndUpdateUI()
        loadTrackersAndCategories()
    }
    
    func isTrackerPinned(at indexPath: IndexPath) -> Bool {
        return visibleCategories[indexPath.section].title == "Закрепленные"
    }
    
    func editTracker(at indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
        let vc = HabitCreationScreenVC()
        vc.delegate = self
        let tracker = self.visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
        vc.categoryName = self.visibleCategories[indexPath.section].title
        vc.selectedCategory = self.visibleCategories[indexPath.section]
        vc.setupEditTracker(tracker: tracker)
        vc.isEditingTracker = true
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
        let alert = UIAlertController(
            title: "",
            message: "Уверены, что хотите удалить трекер?",
            preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) {
            [weak self] _ in
            guard let self = self else { return }
            let tracker = visibleCategories[indexPath.section].arrayTrackers[indexPath.row]
            trackerStore.deleteTracker(tracker: tracker)
            
            fetchCategoryAndUpdateUI()
            loadTrackersAndCategories()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func fetchCategoryAndUpdateUI() {
        fetchCategory()
        visibleCategories = categories
        
        if let pinnedIndex = visibleCategories.firstIndex(where: { $0.title == "Закрепленные" }) {
            let pinnedCategory = visibleCategories.remove(at: pinnedIndex)
            visibleCategories.insert(pinnedCategory, at: 0)
        }
        
        collectionView.reloadData()
    }
    
    private func ensurePinnedCategoryExists() {
        let pinnedCategoryTitle = "Закрепленные"
        do {
            if try !trackerCategoryStore.fetchCategories().contains(where: { $0.title == pinnedCategoryTitle }) {
                let newCategory = TrackerCategory(title: pinnedCategoryTitle, arrayTrackers: [])
                try trackerCategoryStore.addNewCategory(newCategory)
            }
        } catch {
            print("Failed to ensure pinned category exists: \(error)")
        }
    }
}
    


extension MainScreen: NewTrackerViewControllerDelegate {
    
    func setDateForNewTracker() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: currentDate)
    }
    
    func didCreateNewTracker(_ tracker: Tracker, _ category: TrackerCategory) {
        addTracker(tracker, to: category)
    }
    
    func didEditTracker(_ tracker: Tracker, _ newCategory: TrackerCategory) {
        var oldCategoryIndex: Int?
        var oldTrackerIndex: Int?

        for (categoryIndex, category) in visibleCategories.enumerated() {
            if let trackerIndex = category.arrayTrackers.firstIndex(where: { $0.id == tracker.id }) {
                oldCategoryIndex = categoryIndex
                oldTrackerIndex = trackerIndex
                break
            }
        }

        if let oldCategoryIndex = oldCategoryIndex, let oldTrackerIndex = oldTrackerIndex {
            visibleCategories[oldCategoryIndex].arrayTrackers.remove(at: oldTrackerIndex)

            if visibleCategories[oldCategoryIndex].arrayTrackers.isEmpty {
                visibleCategories.remove(at: oldCategoryIndex)
            }
        }

        if let newCategoryIndex = visibleCategories.firstIndex(where: { $0.title == newCategory.title }) {
            visibleCategories[newCategoryIndex].arrayTrackers.append(tracker)
        } else {
            visibleCategories.append(newCategory)
        }

        if let updatedTrackerCoreData = trackerStore.updateTracker(tracker) {
            if let oldCategoryIndex = oldCategoryIndex {
                let oldCategoryTitle = visibleCategories[oldCategoryIndex].title
                try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: oldCategoryTitle)
            }

            try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: newCategory.title)
        }
        
        collectionView.reloadData()
    }
}

extension MainScreen: TrackerCategoryStoreDelegate {
    func didUpdateCategories() {
        collectionView.reloadData()
    }
}

extension MainScreen {
    private func fetchCategory() {
        do {
            let coreDataCategories = try trackerCategoryStore.fetchCategories()
            categories = coreDataCategories.compactMap { coreDataCategory in
                trackerCategoryStore.updateTrackerCategory(coreDataCategory)
            }
            
            var trackers = [Tracker]()
            
            for visibleCategory in visibleCategories {
                for tracker in visibleCategory.arrayTrackers {
                    let newTracker = Tracker(
                        id: tracker.id,
                        name: tracker.name,
                        color: tracker.color,
                        emoji: tracker.emoji,
                        schedule: tracker.schedule)
                    trackers.append(newTracker)
                }
            }
            
            self.trackers = trackers
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    private func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: titleCategory)
    }
}

extension MainScreen {
    private func fetchRecord()  {
        do {
            completedTrackers = try trackerRecordStore.fetchRecords()
        } catch {
            print("Ошибка при добавлении записи: \(error)")
        }
    }
    
    private func createRecord(record: TrackerRecord)  {
        do {
            try trackerRecordStore.addNewRecord(from: record)
            fetchRecord()
        } catch {
            print("Ошибка при добавлении записи: \(error)")
        }
    }
    
    private func deleteRecord(record: TrackerRecord)  {
        do {
            try trackerRecordStore.deleteTrackerRecord(trackerRecord: record)
            fetchRecord()
        } catch {
            print("Ошибка при удалении записи: \(error)")
        }
    }
}

extension MainScreen {
    private func applyFilter() {
        switch currentFilter {
        case .all:
            filteredTrackers()
        case .today:
            visibleCategories = categories.map { category in
                let trackersForToday = category.arrayTrackers.filter { tracker in
                    return isTrackerScheduledForToday(tracker: tracker)
                }
                return TrackerCategory(title: category.title, arrayTrackers: trackersForToday)
            }.filter { !$0.arrayTrackers.isEmpty }
            collectionView.reloadData()
        case .completed:
            visibleCategories = categories.map { category in
                let completedTrackers = category.arrayTrackers.filter { tracker in
                    return isTrackerCompletedOnDate(tracker: tracker, date: currentDate)
                }
                return TrackerCategory(title: category.title, arrayTrackers: completedTrackers)
            }.filter { !$0.arrayTrackers.isEmpty }
            collectionView.reloadData()
        case .notCompleted:
            visibleCategories = categories.map { category in
                let notCompletedTrackers = category.arrayTrackers.filter { tracker in
                    return !isTrackerCompletedOnDate(tracker: tracker, date: currentDate) && isTrackerScheduledForToday(tracker: tracker)
                }
                return TrackerCategory(title: category.title, arrayTrackers: notCompletedTrackers)
            }.filter { !$0.arrayTrackers.isEmpty }
            collectionView.reloadData()
        }
        
        if visibleCategories.isEmpty {
            showPlaceholder()
        } else {
            hidePlaceholder()
        }
    }
    
    private func isTrackerCompletedOnDate(tracker: Tracker, date: Date) -> Bool {
        return completedTrackers.contains { record in
            record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
    
    private func isTrackerScheduledForToday(tracker: Tracker) -> Bool {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: currentDate) - 1
        let todayString = WeekDay(rawValue: today)?.stringValue ?? ""
        return tracker.schedule.contains(todayString)
    }
    
    private func showPlaceholder() {
        placeholderImageFilter.isHidden = false
        placeholderLabelFilter.isHidden = false
        collectionView.isHidden = true
    }
    
    private func hidePlaceholder() {
        placeholderImageFilter.isHidden = true
        placeholderLabelFilter.isHidden = true
        collectionView.isHidden = false
    }
}

extension MainScreen: FilterViewControllerDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        currentFilter = filter
        applyFilter()
    }
}





