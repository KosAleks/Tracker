//
//  CreateTracker.swift
//  Tracker
//
//  Created by Александра Коснырева on 11.07.2024.
//

import Foundation
import UIKit


final class ChoiceVC: UIViewController {
    private let habitButton = UIButton()
    private let eventButton = UIButton()
    private let label = UILabel()
    weak var delegate: NewTrackerViewControllerDelegate?
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.viewBackgroundColor
        createNavigation()
        createHabitButton()
        creatEventButton()
    }
    
    //MARK: Methods for setup UI
    
    private func createHabitButton() {
        habitButton.backgroundColor = Colors.ypBlack
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: .medium)
        habitButton.setTitleColor(Colors.ypWhite, for: .normal)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitButton)
        habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        habitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
    }
    
    private func creatEventButton() {
        eventButton.backgroundColor = Colors.ypBlack
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        eventButton.setTitleColor(Colors.ypWhite, for: .normal)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventButton)
        eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 20).isActive = true
        eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        eventButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        eventButton.layer.cornerRadius = 16
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
    }
    
    private func createNavigation() {
        navigationItem.title = "Создание трекера"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    //MARK: Metods
    
    private func swithToHabitCreationScreen() {
        let habitCreationVC = HabitCreationScreenVC()
        habitCreationVC.delegate = delegate
        navigationController?.pushViewController(habitCreationVC, animated: true)
    }
    
    private func switchToMainScreen() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    private func  switchToIrregularEventScreen() {
        let irregularEventVC = IrregularEventVC()
        irregularEventVC.delegate = delegate
        navigationController?.pushViewController(irregularEventVC, animated: true)
    }
    
    //MARK: Objc metods
    
    @objc func habitButtonTapped() {
        swithToHabitCreationScreen()
    }
    
    @objc func eventButtonTapped() {
        switchToIrregularEventScreen()
    }
}



