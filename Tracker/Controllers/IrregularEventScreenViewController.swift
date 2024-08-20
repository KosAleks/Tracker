//
//  IrregularEventScreenViewController.swift
//  Tracker
//
//  Created by Александра Коснырева on 03.08.2024.
//

import Foundation
import UIKit

final class IrregularEventVC: BaseVCClass {
    private let constant = Constants()
    weak var delegate: NewTrackerViewControllerDelegate?
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")
        createScrollView()
        createConteinerView()
        createEnterTrackerName()
        enterTrackerName.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        createTableView()
        setupCollectionViewForHabitVC()
        collectionViewForHabitVC.dataSource = self
        collectionViewForHabitVC.delegate = self
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
        setupButtonStack()
        hideKeyboardWhenTappedAround() 
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bottomInset = view.safeAreaInsets.bottom + 60 // 60 - высота кнопки
        scrollView.contentInset.bottom = bottomInset
        scrollView.scrollIndicatorInsets.bottom = bottomInset
    }
    
    //MARK: @objc methods
    
    @objc func cancelButtonForIrregularEventTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonForIrregularEventTapped() {
        guard let newTrackerName = enterTrackerName.text else { return }
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: date)
        
        let newTracker = Tracker(
            id: UUID(),
            name: newTrackerName,
            color: selectedColor ?? constant.color,
            emoji: selectedEmoji ?? constant.emojiArray.randomElement() ?? "🐶",
            schedule: dayString
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

extension IrregularEventVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return constant.emojiArray.count
        case 1:
            return Constants.colorSelection.count //18 цветов
        default:
            return 18
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewTrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? NewTrackerCollectionViewCell else {
            assertionFailure("Unable to dequeue NewTrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.setEmoji(constant.emojiArray[indexPath.row])
            
        default:
            if let color = Constants.colorSelection[indexPath.row] {
                cell.setColor(color)
                
            }
        }
        return cell
    }    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = NewTrackerSupplementaryView.reuseIdentifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as? NewTrackerSupplementaryView else {
            assertionFailure("Unable to dequeue NewTrackerSupplementaryView")
            return UICollectionReusableView()
        }
        switch indexPath.section {
        case 0:
            view.setTitle("Emoji")
        case 1:
            view.setTitle("Цвет")
        default:
            view.setTitle("titli")
        }
        return view
    }
}

extension IrregularEventVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: 34),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension IrregularEventVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForVisibleItems.filter({
            $0.section == indexPath.section
        }).forEach({
            collectionView.deselectItem(at: $0, animated: true)
        })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedEmoji = constant.emojiArray[indexPath.row]
        case 1:
            selectedColor = Constants.colorSelection[indexPath.row]
        default:
            break
        }
        textChanged()
    }
}

