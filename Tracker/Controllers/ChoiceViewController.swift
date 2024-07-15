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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        self.title = "Создание трекера"
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
        habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 395).isActive = true
        habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        habitButton.widthAnchor.constraint(equalToConstant: 335).isActive = true
        habitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(self, action: #selector(habbitButtonTapped), for: .touchUpInside)
    }
    
    func creatIrregularEventButton() {
        irregularEventButton.backgroundColor = UIColor(named: "blackColor")
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.setTitleColor(UIColor(named: "whiteButton"), for: .normal)
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(irregularEventButton)
        irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16).isActive = true
        irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        irregularEventButton.widthAnchor.constraint(equalToConstant: 335).isActive = true
        irregularEventButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
    }
    
    @objc func habbitButtonTapped() {
        swithToHabitCreationScreen()
    }
    
    @objc func irregularEventButtonTapped() {
        
    }
    
    func swithToHabitCreationScreen() {
        let habitCreationVC = HabitCreationScreenVC()
        let navigationVC = UINavigationController(rootViewController: habitCreationVC)
        navigationVC.modalPresentationStyle = .pageSheet
        present(navigationVC, animated: true)
    }
}



