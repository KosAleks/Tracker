import Foundation
import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func setDateForNewTracker() -> String
    func didCreateNewTracker(_ tracker: Tracker)
}

final class HabitCreationScreenVC: UIViewController {
    let labelNewHabit = UILabel()
    let enterTrackerName = UITextField()
    let tableView = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    var trackerName = String()
    let constants = Constants()
    var selectedDays: [WeekDay: Bool] = [:]
    
    weak var delegateNewTracker: NewTrackerViewControllerDelegate?
    weak var delegate: MainScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createNavigation()
        createEnterTrackerName()
        createCreateButton()
        createCancelButton()
        tableView.delegate = self
        tableView.dataSource = self
        createTableView()
    }
    
    //MARK: Methods for creating UI
    
    func createEnterTrackerName() {
        enterTrackerName.backgroundColor = UIColor(named: "greyColor")
        enterTrackerName.placeholder = "Введите название трекера"
        enterTrackerName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterTrackerName)
        NSLayoutConstraint.activate([
            enterTrackerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            enterTrackerName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterTrackerName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            enterTrackerName.heightAnchor.constraint(equalToConstant: 75)
        ])
        enterTrackerName.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    func createCreateButton() {
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        createButton.backgroundColor = UIColor(named: "darkGrey")
        createButton.layer.cornerRadius = 16
        createButton.isEnabled = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    func createCancelButton() {
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "coralColor"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "coralColor")?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166)
        ])
        cancelButton.addTarget(self, action: #selector(switchToMainScreen), for: .touchUpInside)
    }
    
    func createTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: enterTrackerName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func createNavigation() {
        navigationItem.title = "Новая привычка"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func switchToScheduleCreator() {
        let scheduleCreator = ScheduleCreatorVC()
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
        guard let date = self.delegateNewTracker?.setDateForNewTracker() else { return }
        
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
        
        self.delegate?.didCreateNewTracker(title: newTrackerName, tracker: newTracker)
        switchToMainScreen()
    }
    
    @objc func textChanged() {
        trackerName = enterTrackerName.text ?? ""
        if trackerName.isEmpty {
            createButton.isEnabled = false
        } else {
            createButtonChanged()
        }
    }
    
    //MARK: methods
    
    func createButtonChanged() {
        createButton.backgroundColor = UIColor(named: "blackColor")
        createButton.isEnabled = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
            
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
            cell.roundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 16)
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
        }
        cell.backgroundColor = UIColor(named: "greyColor")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            switchToScheduleCreator()
        }
    }
}
