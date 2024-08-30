import Foundation
import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func setDateForNewTracker() -> String
    func didCreateNewTracker(_ tracker: Tracker, _ category: TrackerCategory)
    func didEditTracker(_ tracker: Tracker, _ category: TrackerCategory)
}

final class HabitCreationScreenVC: BaseVCClass, ScheduleViewControllerDelegate {
   
    func didSelectDays(_ days: [WeekDay: Bool]) {
        selectedDays = days
        tableView.reloadData()
    }
    private let trackerType: TrackerType = .habit
    private let constants = Constants()
    private var selectedDays: [WeekDay: Bool] = [:]
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    var categoryName: String = "" {
        didSet {
            if !categoryName.isEmpty {
                print(categoryName)
                tableView.reloadData()
            }
        }
    }
    
    var selectedCategory: TrackerCategory? {
        didSet {
            if let category = selectedCategory {
                categoryName = category.title
                tableView.reloadData()
            }
        }
    }
    
    private var schedule: String = " "
    weak var delegate: NewTrackerViewControllerDelegate?
    var isEditingTracker = false
    private var editedTracker: Tracker?
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.viewBackgroundColor
        createScrollView()
        createConteinerView()
        createNavigation()
        navigationItem.title = "Новая привычка"
        createEnterTrackerName()
        enterTrackerName.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        setupButton(
            createButton,
            title: "Создать",
            titleColor: Colors.ypWhite ?? .white,
            backgroundColor: UIColor(named: "darkGrey"),
            borderColor: nil,
            isEnabled: false,
            isCancelButton: false
        )
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        setupButton(
            cancelButton,
            title: "Отменить",
            titleColor: UIColor(named: "coralColor") ?? .red,
            backgroundColor: Colors.ypWhite,
            borderColor: UIColor(named: "coralColor"),
            isEnabled: true,
            isCancelButton: true
        )
        cancelButton.addTarget(self, action: #selector(switchToMainScreen), for: .touchUpInside)
        createTableViewForHabit()
        tableView.register(CustomCellHabit.self, forCellReuseIdentifier: CustomCellHabit.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        hideKeyboardWhenTappedAround()
        setupCollectionViewForHabitVC()
        setupButtonStack()
        collectionViewForHabitVC.dataSource = self
        collectionViewForHabitVC.delegate = self
    }
    
    
    
    // MARK: Methods for setupUI
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bottomInset = view.safeAreaInsets.bottom + 114
        scrollView.contentInset.bottom = bottomInset
        scrollView.scrollIndicatorInsets.bottom = bottomInset
    }
    
    //MARK: Methods
    
    private func switchToScheduleCreator() {
        let scheduleCreator = ScheduleCreatorVC()
        scheduleCreator.delegate = self
        scheduleCreator.selectedDays = selectedDays
        scheduleCreator.onDoneButtonPressed = {
            [weak self] in self?.elemetsOfTrackerChanged()
        }
        navigationController?.pushViewController(scheduleCreator, animated: true)
    }
    
    //MARK: @objc methods
    
    @objc func switchToMainScreen() {
        dismiss(animated: true)
    }
    
    @objc func createButtonTapped() {
        guard let newTrackerName = enterTrackerName.text else { return }
        guard let date = self.delegate?.setDateForNewTracker() else { return }
        var newTrackerSchedule: [String] = []
        switch trackerType {
        case .habit:
            if selectedDays.values.contains(true) {
                newTrackerSchedule = selectedDays.filter { $0.value }.map { $0.key.stringValue }
            }
        case .event:
            newTrackerSchedule = [date]
        }
        
        let formattedSchedule = newTrackerSchedule.joined(separator: ", ")
        
        let newTracker = Tracker(
            id: UUID(),
            name: newTrackerName,
            color: selectedColor ?? .orange,
            emoji: selectedEmoji ?? Constants.randomEmoji(),
            schedule: formattedSchedule
        )
        let newCategory = TrackerCategory(title: categoryName, arrayTrackers: [newTracker])
        delegate?.didCreateNewTracker(newTracker, newCategory)
        dismiss(animated: true)
    }
    
    func setupEditTracker(tracker: Tracker) {
        isEditingTracker = true
        editedTracker = tracker
        enterTrackerName.text = tracker.name
        schedule = tracker.schedule
        selectedEmoji = tracker.emoji
        selectedColor = tracker.color
        selectedDays = [:]
        
        let days = tracker.schedule.components(separatedBy: ", ")
        for day in days {
            switch day {
            case "Пн": selectedDays[.Monday] = true
            case "Вт": selectedDays[.Tuesday] = true
            case "Ср": selectedDays[.Wednesday] = true
            case "Чт": selectedDays[.Thursday] = true
            case "Пт": selectedDays[.Friday] = true
            case "Сб": selectedDays[.Saturday] = true
            case "Вс": selectedDays[.Sunday] = true
            default: break
            }
        }
        tableView.reloadData()
        collectionViewForHabitVC.reloadData()
        elemetsOfTrackerChanged()
    }
}

//MARK: Extensions

extension HabitCreationScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellHabit.identifier, for: indexPath) as! CustomCellHabit
        if indexPath.row == 0 {
            cell.setDescription(categoryName)
            cell.textLabel?.text = "Категория"
            cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
            cell.isUserInteractionEnabled = true
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
            cell.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 16)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.layoutMargins = UIEdgeInsets.zero
            
            let selectedDaysArray = selectedDays.filter { $0.value }.map { $0.key }
            if selectedDaysArray.isEmpty {
                cell.setDescription("")
            } else if selectedDaysArray.count == WeekDay.allCases.count {
                cell.setDescription("Каждый день")
            } else {
                let selectedDaysString = selectedDaysArray.map { $0.stringValue }.joined(separator: ", ")
                cell.setDescription(selectedDaysString)
            }
        } else {
            cell.setDescription("")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let trackerCategoryStore = TrackerCategoryStore()
            let categoryViewModel = CategoryViewModel(trackerCategoryStore: trackerCategoryStore)
            let categoryVC = CategoryViewController(viewModel: categoryViewModel)
            categoryVC.selectedCategory = categoryName
            categoryVC.delegate = self
            elemetsOfTrackerChanged()
            navigationController?.pushViewController(categoryVC, animated: true)
        case 1:
            let scheduleVC = ScheduleCreatorVC()
            scheduleVC.selectedDays = selectedDays
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        default:
            break
        }
    }
}

extension HabitCreationScreenVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constants.emojiArray.count
        case 1:
            return Constants.colorSelection.count //18 цветов
        default:
            return 18
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewTrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? NewTrackerCollectionViewCell else {
            assertionFailure("Unable to dequeue NewTrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.setEmoji(Constants.emojiArray[indexPath.row])
            
        default:
            if let color = Constants.colorSelection[indexPath.row] {
                cell.setColor(color)
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = NewTrackerSupplementaryView.reuseIdentifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as? NewTrackerSupplementaryView else {
            assertionFailure("Unable to dequeue NewTrackerSupplementaryView")
            return UICollectionReusableView()
        }
        switch indexPath.section {
        case 0:
            view.setTitle("Emoji")
        case 1:
            view.setTitle("Цвет")
        default:
            view.setTitle("title")
        }
        return view
    }
}

extension HabitCreationScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: 34),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 34, right: 0)
    }
}

extension HabitCreationScreenVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForVisibleItems.filter({
            $0.section == indexPath.section
        }).forEach({
            collectionView.deselectItem(at: $0, animated: true)
        })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedEmoji = Constants.emojiArray[indexPath.row]
            elemetsOfTrackerChanged()
        case 1:
            selectedColor = Constants.colorSelection[indexPath.row]
            elemetsOfTrackerChanged()
        default:
            break
        }
    }
    
    @objc func textChanged() {
        self.trackerName = enterTrackerName.text ?? ""
        if trackerName.isEmpty == false {
            elemetsOfTrackerChanged()
        } else {
            createButton.isEnabled = false
        }
    }
    
    private func elemetsOfTrackerChanged() -> Bool {
        self.trackerName = enterTrackerName.text ?? ""
        if  self.trackerName.isEmpty == false &&
                self.selectedColor != nil &&
                self.selectedEmoji?.isEmpty == false &&
                self.categoryName.isEmpty == false &&
                self.selectedDays.contains(where: { $0.value == true }) {
            createButtonChanged()
            return true
        } else {
            createButton.isEnabled = false
            return false
        }
    }
}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

extension HabitCreationScreenVC: CategoryViewControllerDelegate {
    func didSelectCategory(_ category: String) {
        categoryName = category
        tableView.reloadData()
    }
    
    func didSelectCategoryEditMode(_ category: TrackerCategory) {
        selectedCategory = category
        tableView.reloadData()
    }
}


