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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods for setup UI
    
    private func createLabel() {
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Constants.whiteColor
        label.numberOfLines = 2 //текст может занимать до 2х строк
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
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
        contentView.addSubview(emojView)
        emojView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12).isActive = true
        emojView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12).isActive = true
        emojView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emojView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func createQuantityButton() {
        quantityButton.layer.cornerRadius = 17
        quantityButton.tintColor = Constants.whiteColor
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
        quantityLabel.textColor = Constants.blackColor
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
        let daysForms = ["дней", "день", "дня"]
        let remainder100 = count % 100
        let remainder10 = count % 10
        // Индекс формы слова "день" в массиве, который будем использовать
        var formIndex: Int
        
        switch remainder100 {
        case 11...14: // Если остаток от 11 до 14, используем форму "дней"
            formIndex = 0
        default:
            switch remainder10 {
            case 1: // Если остаток равен 1 и число не оканчивается на 11, используем форму "день"
                formIndex = 1
            case 2...4: // Если остаток от 2 до 4 и число не оканчивается на 12, 13, 14, используем форму "дня"
                formIndex = 2
            default: // Во всех остальных случаях, используем форму "дней"
                formIndex = 0
            }
        }
        return "\(count) \(daysForms[formIndex])"
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


