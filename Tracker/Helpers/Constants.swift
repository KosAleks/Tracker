//
//  Constants.swift
//  Tracker
//
//  Created by Александра Коснырева on 17.07.2024.
//

import Foundation
import UIKit

final class Constants {
    static let emojiArray = [
        "🏝️", "🥰", "🤩", "🥳", "✈️", "💯",
        "😈", "😻", "❤️", "👀", "💃", "👨‍👩‍👧‍👦",
        "🐶", "🪴", "🍎", "🥑", "🍷", "🛼"
    ]
    
    let colorNames = (1...18).map { "\($0)" } // создала массив строк
    lazy var colorArray = colorNames.map { UIColor(named: $0) ?? .green }
    lazy var color = colorArray.randomElement() ?? .green
    static let colorSelection = (1...18).map({ UIColor(named: String($0)) })
}

extension Constants {
    static func randomEmoji() -> String {
        return emojiArray.randomElement() ?? "🦖"
    }
}

extension Constants {
    static let blue = UIColor(named: "blueColor")
    static let black = UIColor(named: "blackColor")
    static let white = UIColor(named: "whiteColor")
    static let coral = UIColor(named: "coralColor")
    static let grey = UIColor(named: "greyColor")
    static let darkGrey = UIColor(named: "darkGrey")
}
