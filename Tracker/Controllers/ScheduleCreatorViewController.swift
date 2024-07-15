//
//  ScheduleCreatorViewController.swift
//  Tracker
//
//  Created by Александра Коснырева on 13.07.2024.
//

import Foundation
import UIKit

final class ScheduleCreatorVC: UIViewController, UITableViewDelegate {
    let doneButton = UIButton()
    let tableViewShedule = UITableView()
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Расписание"
        view.backgroundColor = UIColor(named: "whiteColor")
        createDoneButton()
        tableViewShedule.dataSource = self
        tableViewShedule.delegate = self
        createTableViewShedule()
        
    }
    
    func createDoneButton() {
        doneButton.backgroundColor = UIColor(named: "blackColor")
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 16
        view.addSubview(doneButton)
        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 335).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func createTableViewShedule() {
        tableViewShedule.translatesAutoresizingMaskIntoConstraints = false
        tableViewShedule.register(CustomCell.self, forCellReuseIdentifier: "cellShedule")
        view.addSubview(tableViewShedule)
        tableViewShedule.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableViewShedule.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableViewShedule.widthAnchor.constraint(equalToConstant: 343).isActive = true
        tableViewShedule.heightAnchor.constraint(equalToConstant: 525).isActive = true
        tableViewShedule.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47).isActive = true
    }
}

extension ScheduleCreatorVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellShedule", for: indexPath) as! CustomCell
            cell.textLabel?.text = daysOfWeek[indexPath.row]
        if indexPath.row == 0 {
            cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        }
        else if indexPath.row == 6 {
            cell.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 16)
        }
        let switchControll = UISwitch()
        switchControll.addTarget(self, action: #selector(print1(_:)), for: .valueChanged)
        cell.accessoryView = switchControll
        cell.backgroundColor = UIColor(named: "greyColor")
        return cell
    }
    
    @objc func print1(_ selector: UISwitch) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 525/7
    }
}

