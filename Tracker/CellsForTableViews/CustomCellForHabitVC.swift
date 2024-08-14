//
//  CellViews.swift
//  Tracker
//
//  Created by Александра Коснырева on 13.07.2024.
//

import Foundation
import UIKit

final class CustomCellHabit: UITableViewCell {
    static let identifier = "habitCell"
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell")
        setupUI()
    }
    
    //MARK: Methods for setup UI
    
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        backgroundColor = UIColor(named: "greyColor")
        accessoryType = .disclosureIndicator
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 46),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func setDescription(_ model: String) {
        detailTextLabel?.text = model
        detailTextLabel?.textColor = UIColor(named: "darkGrey")
        detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        if detailTextLabel?.text != "" {
            detailTextLabel?.isHidden = false
        } else {
            detailTextLabel?.isHidden = true
        }
    }
}
