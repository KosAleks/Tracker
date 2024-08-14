//
//  IrregularEventScreenViewController.swift
//  Tracker
//
//  Created by Александра Коснырева on 03.08.2024.
//

import Foundation
import UIKit

final class IrregularEventVC: BaseVCClass {
    private var selectedColorEvent: UIColor?
    private var selectedEmojiEvent: String?
    private let constant = Constants()
    weak var delegate: NewTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createScrollView()
        createConteinerView()
        createEnterTrackerName()
        enterTrackerName.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        createTableView()
        setupButton(
            createButton,
            title: "Создать",
            titleColor: UIColor(named: "whiteColor") ?? .white,
            backgroundColor: UIColor(named: "darkGrey"),
            borderColor: nil,
            isEnabled: false,
            isCancelButton: false
        )
        createButton.addTarget(self, action: #selector(createButtonForIrregularEventTapped) , for: .touchUpInside)
        
        setupButton(
            cancelButton,
            title: "Отменить",
            titleColor: UIColor(named: "coralColor") ?? .red,
            backgroundColor: UIColor(named: "whiteColor"),
            borderColor: UIColor(named: "coralColor"),
            isEnabled: true,
            isCancelButton: true
        )
        cancelButton.addTarget(self, action: #selector(cancelButtonForIrregularEventTapped) , for: .touchUpInside)
        createNavigation()
        navigationItem.title = "Новое нерегулярное событие"
        tableView.register(CustomCellForIrregularEvent.self, forCellReuseIdentifier: CustomCellForIrregularEvent.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: @objc methods
    
    @objc func cancelButtonForIrregularEventTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonForIrregularEventTapped() {
        guard let newTrackerName = enterTrackerName.text else { return }
        
        // Предположим, что у вас есть DatePicker и вы получили из него дату
        let date = Date() // Здесь можно заменить на datePicker.date
        
        // Создаем DateFormatter
        let dateFormatter = DateFormatter()
        
        // Устанавливаем формат только для дня
        dateFormatter.dateFormat = "dd"
        
        // Преобразуем дату в строку
        let dayString = dateFormatter.string(from: date)
        
        // Выводим строку
        print(dayString) // выводит сегодняшний день 14,- формат стринг 
        
        //let datePickerDate = mainScreen.datePicker.date // текущая дата
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = " dd "
        
        // let string = dateFormatter.string(from: datePickerDate)
        let stringArray: [String] = [dayString]
        
        let newTracker = Tracker(
            id: UUID(),
            name: newTrackerName,
            color: selectedColorEvent ?? constant.color,
            emoji: selectedEmojiEvent ?? constant.emojiArray.randomElement() ?? "🐶",
            schedule: stringArray // здесь лежит одна текущая дата но нам нужна та которая в момент создания в дэйт пикер
        )
        delegate?.didCreateNewTracker(newTracker)
        dismiss(animated: true)
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
        cell.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 16)
        cell.backgroundColor = UIColor(named: "greyColor")
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) //убираем нижнюю черту
        cell.layoutMargins = UIEdgeInsets.zero
        // cell.setDescription("") раскомментить и добавить что дб в detailTextLabel
        return cell
    }
}
