//
//  TrackerCreationScreen.swift
//  Tracker
//
//  Created by Александра Коснырева on 11.07.2024.
//

import Foundation
import UIKit

final class HabitCreationScreenVC: UIViewController, UITableViewDelegate {
    let labelNewHabit = UILabel()
    let enterTrackerName = UITextField()
    let tableView = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createEnterTrackerName()
        createCreateButton()
        createCancelButton()
        self.title = "Новая привычка"
        tableView.delegate = self
        tableView.dataSource = self
        createTableView()
    }
    
    func createEnterTrackerName() {
        enterTrackerName.backgroundColor = UIColor(named: "greyColor")
        enterTrackerName.text = "Введите название трекера"
        enterTrackerName.textColor = UIColor(named: "darkGrey")
        enterTrackerName.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        enterTrackerName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterTrackerName)
        enterTrackerName.topAnchor.constraint(equalTo: view.topAnchor, constant: 138).isActive = true
        enterTrackerName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        enterTrackerName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        enterTrackerName.widthAnchor.constraint(equalToConstant: 343).isActive = true
        enterTrackerName.heightAnchor.constraint(equalToConstant: 75).isActive = true
        enterTrackerName.layer.cornerRadius = 16
    }
    
    func createCreateButton() {
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        createButton.backgroundColor = UIColor(named: "darkGrey")
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 166).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
    }
    
    func createTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: enterTrackerName.bottomAnchor, constant: 24).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func switchToScheduleCreator() {
        let scheduleCreator = ScheduleCreatorVC()
        let navVC = UINavigationController(rootViewController: scheduleCreator)
        navVC.modalPresentationStyle = .pageSheet
        present(navVC, animated: true)
    }
}

extension HabitCreationScreenVC: UITableViewDataSource {
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
}
    
