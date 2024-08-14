import Foundation
import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func setDateForNewTracker() -> String
    func didCreateNewTracker(_ tracker: Tracker)
}

final class HabitCreationScreenVC: BaseVCClass, ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [WeekDay: Bool]) {
            selectedDays = days
            tableView.reloadData()
        }
    private let constants = Constants()
    private var selectedDays: [WeekDay: Bool] = [:]
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
            createScrollView()
            createConteinerView()
            createNavigation()
            navigationItem.title = "Новая привычка"
            createEnterTrackerName()
            enterTrackerName.addTarget(self, action: #selector(textChanged), for: .editingChanged)
            setupButton(
                createButton,
            title: "Создать",
            titleColor: UIColor(named: "whiteColor") ?? .white,
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
            backgroundColor: UIColor(named: "whiteColor"),
            borderColor: UIColor(named: "coralColor"),
            isEnabled: true,
            isCancelButton: true
        )
            cancelButton.addTarget(self, action: #selector(switchToMainScreen), for: .touchUpInside)
       
            createTableView()
            tableView.register(CustomCellHabit.self, forCellReuseIdentifier: CustomCellHabit.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            hideKeyboardWhenTappedAround() 
    }
   
    //MARK: Methods
    
    private func switchToScheduleCreator() {
        let scheduleCreator = ScheduleCreatorVC()
        scheduleCreator.delegate = self
        scheduleCreator.selectedDays = selectedDays
        scheduleCreator.onDoneButtonPressed = {
            [weak self] in self?.createButtonChanged()
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
        
        if selectedDays.values.contains(true) {
            newTrackerSchedule = selectedDays.filter { $0.value }.map { $0.key.stringValue }
        } else {
            newTrackerSchedule = [date]
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: newTrackerName,
            color: constants.color,
            emoji: constants.emojiArray.randomElement() ?? "🐶",
            schedule: newTrackerSchedule
        )
        
        self.delegate?.didCreateNewTracker(newTracker)
        switchToMainScreen()
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
            cell.textLabel?.text = "Категория"
            cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
            cell.isUserInteractionEnabled = false
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
            cell.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 16)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.layoutMargins = UIEdgeInsets.zero
            
            let selectedDaysArray = selectedDays.filter { $0.value }.map { $0.key }
            if selectedDaysArray.isEmpty {
                cell.setDescription("")
            } else if selectedDaysArray.count == WeekDay.allCases.count {
                cell.setDescription("Каждый день") // Отображаем "Каждый день", если выбраны все дни
            } else {
                let selectedDaysString = selectedDaysArray.map { $0.stringValue }.joined(separator: ", ")
                cell.setDescription(selectedDaysString) //отображаем выбранные дни
            }
        } else {
            cell.setDescription("") // Очищаем описание для других ячеек
        }
        return cell
    }

            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                switch indexPath.row {
                case 0:
                    let categoryVC = CategoryViewController()
                    navigationController?.pushViewController(categoryVC, animated: true)
                case 1:
                    switchToScheduleCreator()
                default:
                    break
                }
            }
}
