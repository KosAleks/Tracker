//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Александра Коснырева on 15.07.2024.
//

import Foundation
import UIKit

final class SupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "SupplementaryViewHeader"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupTitleLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    
    private func setupTitleLable() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.tintColor = .black
    }
}
