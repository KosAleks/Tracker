//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Александра Коснырева on 15.07.2024.
//

import Foundation
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let emoji = UILabel()
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
        
        contentView.addSubview(emoji)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
    createTitleLabel()
        createEmoji()
    }
    
    private func createTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Домашний уют"
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = UIColor(named: "blackColor")
    
    }
    
    private func createEmoji() {
        emoji.text = "😪"
      
    }
    
    
}
