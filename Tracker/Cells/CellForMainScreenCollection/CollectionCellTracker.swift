//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Александра Коснырева on 15.07.2024.
//

import Foundation
import UIKit

protocol TrackerCollectionCellDelegate: AnyObject {
    func record(_ sender: Bool, _ cell: CollectionCellTracker)
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
    func pinTracker(at indexPath: IndexPath)
    func unpinTracker(at indexPath: IndexPath)
    func editTracker(at indexPath: IndexPath)
    func deleteTracker(at indexPath: IndexPath)
    func isTrackerPinned(at indexPath: IndexPath) -> Bool
}

final class CollectionCellTracker: UICollectionViewCell {
    static let reuseIdentifier = "collectionCell"
    weak var delegate: TrackerCollectionCellDelegate?
    private var quantity: Int = 0
    private var trackerIsCompleted: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    private let label: UILabel = UILabel()
    private let colorView = UIView()
    private let emojView = UILabel()
    private let quantityButton = UIButton()
    private let quantityLabel = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        createColorView()
        createEmojiView()
        createLabel()
        createQuantityButton()
        createQuantityLabel()
        let interaction = UIContextMenuInteraction(delegate: self)
        colorView.addInteraction(interaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods for setup UI
    
    private func createLabel() {
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2 //текст может занимать до 2х строк
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(label)
        label.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12).isActive = true
        label.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12).isActive = true
        label.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12).isActive = true
    }
    
    private func createColorView() {
        colorView.layer.cornerRadius = 16
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        colorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func createEmojiView() {
        emojView.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emojView.textAlignment = .center
        emojView.backgroundColor = .white.withAlphaComponent(0.3)
        emojView.layer.cornerRadius = 12
        emojView.layer.masksToBounds = true
        emojView.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(emojView)
        emojView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12).isActive = true
        emojView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12).isActive = true
        emojView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emojView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func createQuantityButton() {
        quantityButton.layer.cornerRadius = 17
        quantityButton.tintColor = .white
        quantityButton.clipsToBounds = true
        quantityButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityButton)
        quantityButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8).isActive = true
        quantityButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor).isActive = true
        quantityButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        quantityButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        quantityButton.addTarget(self, action: #selector(quantityButtonTapped), for: .touchUpInside)
    }
    
    private func  createQuantityLabel() {
        quantityLabel.text = "1 день"
        quantityLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        quantityLabel.textColor = .black
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityLabel)
        quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        quantityLabel.trailingAnchor.constraint(equalTo: quantityButton.leadingAnchor, constant: -8).isActive = true
        quantityLabel.centerYAnchor.constraint(equalTo: quantityButton.centerYAnchor).isActive = true
    }
    
    //MARK: Methods
    
    func configure(with tracker: Tracker, completedDays: Int, trackerIsCompleted: Bool, indexPath: IndexPath) {
        label.text = tracker.name
        colorView.backgroundColor = tracker.color
        emojView.text = tracker.emoji
        self.trackerIsCompleted = trackerIsCompleted
        self.trackerId = tracker.id
        self.indexPath = indexPath
        quantityLabel.text = setQuantityLabelText(completedDays)
        let imageName = trackerIsCompleted ? "checkmark" : "plus"
        if let image = UIImage(systemName: imageName) {
            quantityButton.setImage(image, for: .normal)
        }
        
        quantityLabel.text = setQuantityLabelText(completedDays)
        quantityLabel.font =  UIFont.systemFont(ofSize: 12, weight: .medium)
        setupQuantityButton(with: tracker)
    }
    
    private func setupQuantityButton(with tracker: Tracker) {
        switch quantityButton.currentImage {
        case UIImage(systemName: "plus"):
            quantityButton.backgroundColor = tracker.color
        case UIImage(systemName: "checkmark"):
            quantityButton.backgroundColor =  tracker.color.withAlphaComponent(0.3)
        case .none:
            break
        case .some(_):
            break
        }
        _ = UIImage(systemName: "checkmark")
        _ = UIImage(systemName: "plus")
        print("Current image: \(quantityButton.currentImage?.description ?? "none")")
    }
    
    private func setQuantityLabelText(_ count: Int) -> String {
        let language = Locale.current.languageCode
        if language == "ru" {
            // Логика для русского языка
            let daysForms = [
                NSLocalizedString("days_many", comment: "Plural form for days"),
                NSLocalizedString("day", comment: "Singular form for day"),
                NSLocalizedString("days_few", comment: "Few form for days")
            ]

            let remainder100 = count % 100
            let remainder10 = count % 10
            var formIndex: Int
            
            switch remainder100 {
            case 11...14:
                formIndex = 0
            default:
                switch remainder10 {
                case 1:
                    formIndex = 1
                case 2...4:
                    formIndex = 2
                default:
                    formIndex = 0
                }
            }
            
            return "\(count) \(daysForms[formIndex])"
        } else {
            // Логика для английского языка
            let dayString = count == 1 ? NSLocalizedString("day", comment: "Singular form for day") : NSLocalizedString("days_few", comment: "Plural form for days")
            return "\(count) \(dayString)"
        }
    }
    
    //MARK: @objc methods
    
    @objc private func quantityButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no trackerId and indexPath")
            return
        }
        if trackerIsCompleted {
            self.delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            self.delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}


extension CollectionCellTracker: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPath else { return nil }
        
        let configContextMenu = UIContextMenuConfiguration(actionProvider: { _ in
            let isPinned = self.delegate?.isTrackerPinned(at: indexPath) ?? false
            let pinTitle = isPinned ? "Открепить" : "Закрепить"
            
            let pinAction = UIAction(title: pinTitle) { _ in
                if isPinned {
                    self.delegate?.unpinTracker(at: indexPath)
                } else {
                    self.delegate?.pinTracker(at: indexPath)
                }
            }
            
            let editAction = UIAction(title: "Редактировать") { _ in
                self.delegate?.editTracker(at: indexPath)
            }
            
            let deleteAction = UIAction(title: "Удалить",
                                  attributes: .destructive) { _ in
                self.delegate?.deleteTracker(at: indexPath)
            }
            
            let actions = [pinAction, editAction, deleteAction]
            return UIMenu(title: "", children: actions)
        })
        
        return configContextMenu
    }
}

