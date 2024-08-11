//
//  CreateTracker.swift
//  Tracker
//
//  Created by Александра Коснырева on 11.07.2024.
//

import Foundation
import UIKit


final class ChoiceVC: UIViewController {
    
    let habitButton = UIButton()
    let irregularEventButton = UIButton()
    let label = UILabel()
    weak var delegate: NewTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createNavigation()
        createHabitButton()
        creatIrregularEventButton()
    }
    
    func createHabitButton() {
        habitButton.backgroundColor = UIColor(named: "blackColor")
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .medium)
        habitButton.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitButton)
        habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        habitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
    }
    
    func creatIrregularEventButton() {
        irregularEventButton.backgroundColor = UIColor(named: "blackColor")
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.setTitleColor(UIColor(named: "whiteButton"), for: .normal)
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(irregularEventButton)
        irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 20).isActive = true
        irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        irregularEventButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
    }
    
    func createNavigation() {
        navigationItem.title = "Создание трекера"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    //MARK: Objc metods
    @objc func habitButtonTapped() {
        swithToHabitCreationScreen()
    }
    
    @objc func irregularEventButtonTapped() {
        switchToIrregularEventScreen()
    }
    
    //MARK: Metods
    func swithToHabitCreationScreen() {
        let habitCreationVC = HabitCreationScreenVC()
        habitCreationVC.delegate = delegate
        navigationController?.pushViewController(habitCreationVC, animated: true)
    }
    
    func switchToMainScreen() {
        if let navigationController = self.navigationController {
                   navigationController.popToRootViewController(animated: true)
               } else {
                   self.dismiss(animated: true)
               }
           }
    
    func  switchToIrregularEventScreen() {
        let irregularEventVC = IrregularEventVC()
        irregularEventVC.delegate = delegate
        navigationController?.pushViewController(irregularEventVC, animated: true)
    }
}



