//
//  IrregularEventScreenViewController.swift
//  Tracker
//
//  Created by Александра Коснырева on 03.08.2024.
//

import Foundation
import UIKit

final class IrregularEventVC: UIViewController {
    
    let cancelButton = UIButton()
    let createButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createNavigation()
        createCreateButton()
        createCancelButton()
    }
    
    private func createNavigation() {
        navigationItem.title = "Новое нерегулярное событие"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    //MARK: @objc methods
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        //TODO: create metod
    }
    
    //MARK: methods
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
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    
}
