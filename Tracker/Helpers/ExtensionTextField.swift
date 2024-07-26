//
//  ExtensionTextField.swift
//  Tracker
//
//  Created by Александра Коснырева on 16.07.2024.
//

import Foundation
import UIKit
extension UITextField {
    @IBInspectable var characterLimit: Int {
        get {
            if let characterLimit = objc_getAssociatedObject(self, &maxLengthKey) as? Int {
                return characterLimit
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &maxLengthKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }

    @objc func limitLength() {
        if let text = self.text, text.count > characterLimit {
            self.text = String(text.prefix(characterLimit))
        }
    }
}

private var maxLengthKey: UInt8 = 0

