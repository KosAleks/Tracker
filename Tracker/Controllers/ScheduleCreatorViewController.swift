//
//  ScheduleCreatorViewController.swift
//  Tracker
//
//  Created by Александра Коснырева on 13.07.2024.
//

import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: [WeekDay: Bool])
}

final class ScheduleCreatorVC: UIViewController, UITableViewDelegate, ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [WeekDay: Bool]) {
        selectedDays = days
        tableViewShedule.reloadData()
    }
    
    weak var delegate: ScheduleViewControllerDelegate?
    private let doneButton = UIButton()
    private let tableViewShedule = UITableView()
    var selectedDays: [WeekDay: Bool] = [:]
    private var daysOfWeek = [
        "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"
    ]
    
    private let habitVC = HabitCreationScreenVC()
    var onDoneButtonPressed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
        view.backgroundColor = UIColor(named: "whiteColor")
        createDoneButton()
        tableViewShedule.dataSource = self
        tableViewShedule.delegate = self
        createTableViewShedule()
        WeekDay.allCases.forEach {
            selectedDays[$0] = false
        }
    }
    
    //MARK: Methods for setup UI
    
    private func createDoneButton() {
        doneButton.backgroundColor = UIColor(named: "blackColor")
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 16
        view.addSubview(doneButton)
        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    private func createTableViewShedule() {
        tableViewShedule.translatesAutoresizingMaskIntoConstraints = false
        tableViewShedule.register(ScheduleCellTracker.self, forCellReuseIdentifier: ScheduleCellTracker.reuseIdentifier)
        view.addSubview(tableViewShedule)
        tableViewShedule.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableViewShedule.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableViewShedule.heightAnchor.constraint(equalToConstant: 525).isActive = true
        tableViewShedule.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47).isActive = true
    }
    
    private func createNavigation() {
        navigationItem.title = "Расписание"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
}

//MARK: Extensions

extension ScheduleCreatorVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCellTracker.reuseIdentifier, for: indexPath) as? ScheduleCellTracker else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        } else if indexPath.row == 6 {
            cell.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 16)
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) // убираем нижнюю черту под помследней ячейкой
        }
        
        cell.switchControll.addTarget(self, action: #selector(addDay(sender:)), for: .valueChanged)
        cell.configure(
            title: daysOfWeek[indexPath.row],
            isSwithcOn: selectedDays[WeekDay.allCases[indexPath.row]] ?? false)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 525/7
    }
    
    //MARK: @objc methods
    
    @objc func addDay(sender: UISwitch) {
        
        guard let cell = sender.superview?.superview as? ScheduleCellTracker,
              let indexPath = tableViewShedule.indexPath(for: cell) else { return }
        
        let day = WeekDay.allCases[indexPath.row]
        selectedDays[day] = sender.isOn
    }
    
    @objc func doneButtonPressed() {
        delegate?.didSelectDays(selectedDays)
        onDoneButtonPressed?()
        navigationController?.popViewController(animated: true)
    }
}

