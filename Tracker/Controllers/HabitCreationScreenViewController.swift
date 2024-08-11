import Foundation
import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func setDateForNewTracker() -> String
    func didCreateNewTracker(_ tracker: Tracker)
}

final class HabitCreationScreenVC: UIViewController, ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [WeekDay: Bool]) {
            selectedDays = days
            tableView.reloadData()
        }

    let labelNewHabit = UILabel()
    let enterTrackerName = UITextField()
    let tableView = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    var trackerName = String()
    let constants = Constants()
    var selectedDays: [WeekDay: Bool] = [:]
    private let containerView = UIView()
    private let scrollView = UIScrollView()

    weak var delegate: NewTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createScrollView()
        createConteinerView()
        createNavigation()
        createEnterTrackerName()
        createCreateButton()
        createCancelButton()
        tableView.delegate = self
        tableView.dataSource = self
        createTableView()
    }
    
    //MARK: Methods for creating UI
    private func createScrollView() {
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
    
    private func createConteinerView() {
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
    
    private func createEnterTrackerName() {
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
        enterTrackerName.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    private func createTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: enterTrackerName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
  
    private func createCreateButton() {
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        createButton.backgroundColor = UIColor(named: "darkGrey")
        createButton.layer.cornerRadius = 16
        createButton.isEnabled = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -34),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func createCancelButton() {
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "coralColor"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "coralColor")?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -34),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166)
        ])
        cancelButton.addTarget(self, action: #selector(switchToMainScreen), for: .touchUpInside)
    }
    
   
    private func createNavigation() {
        navigationItem.title = "Новая привычка"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
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
    
    @objc func textChanged() {
        trackerName = enterTrackerName.text ?? ""
        if trackerName.isEmpty {
            createButton.isEnabled = false
        } else {
            createButtonChanged()
        }
    }
    
    //MARK: methods
    
    private func createButtonChanged() {
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
