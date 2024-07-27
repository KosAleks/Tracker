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
    
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2 //текст может занимать до 2х строк
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let emojView:
    UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()

    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let quantityButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.tintColor = .white
        button.clipsToBounds = true
        button.addTarget(
            self,
            action: #selector(quantityButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "1 день"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    weak var delegate: TrackerCollectionViewCellDelegate?
    func setup() {
    setupConstraints()
    }
    private func setupConstraints() {
        [colorView, label, emojView, quantityLabel, quantityButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [colorView, emojView, quantityButton, quantityLabel, label].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 167),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojView.heightAnchor.constraint(equalToConstant: 24),
            emojView.widthAnchor.constraint(equalToConstant: 24),
            
            label.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            label.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            
            quantityButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            quantityButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor),
            quantityButton.heightAnchor.constraint(equalToConstant: 34),
            quantityButton.widthAnchor.constraint(equalToConstant: 34),
            
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            quantityLabel.trailingAnchor.constraint(equalTo: quantityButton.leadingAnchor, constant: -8),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityButton.centerYAnchor)
        ])
    }
    func configure(with tracker: Tracker, completedDays: Int, trackerIsCompleted: Bool, indexPath: IndexPath) {
          //label.text = "Поливать растения"
        label.text = tracker.name
        label.font = UIFont(name: "SFPro-Medium", size: 12)
          colorView.backgroundColor = UIColor(named: "5")
          //colorView.backgroundColor = tracker.color
        emojView.text = "😪"
          //emoji.text = tracker.emoji
        self.trackerIsCompleted = trackerIsCompleted
        self.trackerId = tracker.id
        self.indexPath = indexPath
          setupQuantityButton(with: tracker)
          quantityLabel.text = setQuantityLabelText(completedDays)
          setupQuantityButton(with: tracker)
        
        let imageName = trackerIsCompleted ? "checkmark" : "plus"
        if let image = UIImage(systemName: imageName) {
            quantityButton.setImage(image, for: .normal)
        }
        
        quantityLabel.text = setQuantityLabelText(completedDays)
        quantityLabel.font =  UIFont(name: "SFPro-Medium", size: 12)
        setupQuantityButton(with: tracker)
      }
    
    @objc private func quantityButtonTapped() {
        print("tapped")
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no trackerId and indexPath")
            return
        }

        if trackerIsCompleted {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
    
    private func setupQuantityButton(with tracker: Tracker) {
        switch quantityButton.currentImage {
        case UIImage(systemName: "plus"):
            quantityButton.backgroundColor = UIColor(named: "5")
        case UIImage(systemName: "checkmark"):
            quantityButton.backgroundColor =  UIColor(named: "5")?.withAlphaComponent(0.3)
        case .none:
            break
        case .some(_):
            break
        }
        let plusImage = UIImage(systemName: "checkmark")
        let checkImage = UIImage(systemName: "plus")
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
  }


