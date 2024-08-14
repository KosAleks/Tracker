//
//  Constants.swift
//  Tracker
//
//  Created by Александра Коснырева on 17.07.2024.
//

import Foundation
import UIKit

final class Constants {
    let emojiArray = [
        "🏝️", "🥰", "🤩", "🥳", "✈️", "💯",
        "😈", "😻", "❤️", "👀", "💃", "👨‍👩‍👧‍👦",
        "🐶", "🪴", "🍎", "🥑", "🍷", "🛼"
    ]
    
    let colorNames = (1...18).map { "\($0)" } // создала массив строк
    lazy var colorArray = colorNames.map { UIColor(named: $0) ?? .green }
    lazy var color = colorArray.randomElement() ?? .green
    
}

