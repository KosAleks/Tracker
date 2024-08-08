//
//  PaddiedTextField.swift
//  Tracker
//
//  Created by Александра Коснырева on 07.08.2024.
//

import Foundation
import UIKit

final class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


