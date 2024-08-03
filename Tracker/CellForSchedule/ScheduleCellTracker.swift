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
        switchControll.addTarget(ScheduleCellTracker.self, action: #selector(addDay), for: .valueChanged)
        switchControll.onTintColor = .blue
        return switchControll
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func configure(title: String, isSwithcOn: Bool) {
        titleLabel.text = title
        switchControll.isOn = isSwithcOn
    }
    
    @objc func addDay() {
        
    }
}
