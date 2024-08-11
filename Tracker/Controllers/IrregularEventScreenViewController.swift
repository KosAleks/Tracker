//
//  IrregularEventScreenViewController.swift
//  Tracker
//
//  Created by Александра Коснырева on 03.08.2024.
//

import Foundation
import UIKit

final class IrregularEventVC: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let labelNewEvent = UILabel()
    private let enterEventName = UITextField()
    private let tableView = UITableView()
    private var eventName = String()
    private let constants = Constants()
    private var selectedDays: [WeekDay: Bool] = [:]
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    private let constant = Constants()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createNavigation()
        createCreateButton()
        createCancelButton()
        createScrollView()
        createConteinerView()
        createEnterEventName()
        createCreateButton()
        createCancelButton()
        createTableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createNavigation() {
        navigationItem.title = "Новое нерегулярное событие"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    //MARK: methods
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
    
    private func createCreateButton() {
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
    
    private func createCancelButton() {
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
    
    private func createEnterEventName() {
        enterEventName.backgroundColor = UIColor(named: "greyColor")
        enterEventName.placeholder = "Введите название трекера"
        enterEventName.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(enterEventName)
        enterEventName.layer.cornerRadius = 16
        enterEventName.textColor = UIColor(named: "blackColor")
        enterEventName.characterLimit = 38
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: enterEventName.frame.height))
        enterEventName.leftView = leftPaddingView
        enterEventName.leftViewMode = .always
        UIKit.NSLayoutConstraint.activate([
            enterEventName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            enterEventName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            enterEventName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            enterEventName.heightAnchor.constraint(equalToConstant: 75)
            ])
        enterEventName.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    private func createTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCellForIrregularEvent.self, forCellReuseIdentifier: CustomCellForIrregularEvent.identifier)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: enterEventName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func createButtonChanged() {
        createButton.backgroundColor = UIColor(named: "blackColor")
        createButton.isEnabled = true
    }
    
    
    //MARK: @objc methods
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let newTrackerName = enterEventName.text else { return }
        let newTracker = Tracker(
            id: UUID(),
            name: newTrackerName,
            color: selectedColor ?? constant.color,
            emoji: selectedEmoji ?? constant.emojiArray.randomElement() ?? "🐶",
            schedule: []
        )
        delegate?.didCreateNewTracker(newTracker)
        dismiss(animated: true)
    }
    
    
    @objc func textChanged() {
        eventName = enterEventName.text ?? ""
        if eventName.isEmpty {
            createButton.isEnabled = false
        } else {
            createButtonChanged()
        }
    }
    
}

//MARK: Extensions

extension IrregularEventVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 / 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellForIrregularEvent.identifier, for: indexPath) as! CustomCellForIrregularEvent
            cell.textLabel?.text = "Категория"
            cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        cell.backgroundColor = UIColor(named: "greyColor")
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell.layoutMargins = UIEdgeInsets.zero
       // cell.setDescription("") раскомментить и добавить что дб в detailTextLabel
        return cell
    }
}
