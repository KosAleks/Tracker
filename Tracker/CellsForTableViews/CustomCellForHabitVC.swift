//
//  CellViews.swift
//  Tracker
//
//  Created by Александра Коснырева on 13.07.2024.
//

import Foundation
import UIKit

final class CustomCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
}
