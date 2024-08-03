//
//  TrackerCreationScreen.swift
//  Tracker
//
//  Created by Александра Коснырева on 11.07.2024.
//

import Foundation
import UIKit

final class HabitCreationScreenVC: UIViewController {
    let labelNewHabit = UILabel()
    let enterTrackerName = UITextField()
    let tableView = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    var trackerName = String()
    let constants = Constants()
    
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
        enterTrackerName.characterLimit = 38
        enterTrackerName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterTrackerName)
        NSLayoutConstraint.activate([
               enterTrackerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
               enterTrackerName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               enterTrackerName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               enterTrackerName.heightAnchor.constraint(equalToConstant: 75)
           ])
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
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 166).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 166).isActive = true
        cancelButton.addTarget(self, action: #selector(switchToMainScreen), for: .touchUpInside)
    }
    
    func createTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.topAnchor.constraint(equalTo: enterTrackerName.bottomAnchor, constant: 24).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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
    
}

//MARK: Extensions

extension HabitCreationScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
            cell.roundCorners(corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 16)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
               cell.layoutMargins = UIEdgeInsets.zero
        }
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor =  UIColor(named: "greyColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            print("")
            
        }
        else if indexPath.row == 1 {
            switchToScheduleCreator()
        }
    }
    
    //MARK: @objc methods
    
    @objc func switchToMainScreen() {
        dismiss(animated: true)
    }
    
    @objc func createButtonTapped() {
        self.delegate?.didCreateNewTracker(title: trackerName, tracker: Tracker(
            id: UUID(),
            name: trackerName,
            color: constants.color,
            emoji: constants.emojiArray.randomElement() ?? "🐶",
            schedule: [true, false, true, false, true, false, true]
        ))
        dismiss(animated: true)
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
        self.createButton.backgroundColor = UIColor(named: "blackColor")
        self.createButton.isEnabled = true
    }
}
