//
//  Week days.swift
//  Tracker
//
//  Created by Александра Коснырева on 03.08.2024.
//

import Foundation
enum WeekDay: Int, CaseIterable {
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Sunday = 0
    
    var stringValue: String {
        switch self {
            case .Monday: return "Пн"
            case .Tuesday: return "Вт"
            case .Wednesday: return "Ср"
            case .Thursday: return "Чт"
            case .Friday: return "Пт"
            case .Saturday: return "Сб"
            case .Sunday: return "Вс"
        }
    }
}
