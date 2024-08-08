//
//  CellForSchedule.swift
//  Tracker
//
//  Created by Александра Коснырева on 03.08.2024.
//

import Foundation
import UIKit

final class ScheduleCellTracker: UITableViewCell {
    static let reuseIdentifier = "scheduleCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let switchControll: UISwitch = {
        let switchControll = UISwitch()
        switchControll.onTintColor = .blue
        switchControll.setOn(false, animated: true)
        
        return switchControll
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func configure(title: String, isSwithcOn: Bool) {
        titleLabel.text = title
        switchControll.isOn = isSwithcOn
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = UIColor(named: "greyColor")
       
        [titleLabel, switchControll].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            switchControll.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchControll.widthAnchor.constraint(equalToConstant: 51),
            switchControll.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ])
    }
}
