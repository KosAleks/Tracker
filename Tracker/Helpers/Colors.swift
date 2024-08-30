//
//  Colors.swift
//  Tracker
//
//  Created by Александра Коснырева on 29.08.2024.
//

import Foundation
import UIKit

final class Colors {
    let viewBackgroundColor = UIColor.systemBackground
    static let ypBlack = UIColor(named: "ypBlack")!
        static let ypWhite = UIColor(named: "ypWhite")!
        
    var navigationBarTintColor: UIColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? Colors.ypWhite : Colors.ypBlack
    }
}
