//
//  DecimalTextField.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 08/10/2024.
//

import UIKit

class DecimalTextField: UITextField, UITextFieldDelegate {

    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    // MARK: - Setup Method
    private func setup() {
        self.delegate = self
        self.keyboardType = .decimalPad
    }

    // MARK: - UITextFieldDelegate Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Inverted set of allowed characters (digits and decimal point)
        let inverseSet = CharacterSet(charactersIn: "0123456789.").inverted

        // Separate the input string by characters not in the allowed set
        let components = string.components(separatedBy: inverseSet)

        // Join the components back
        let filtered = components.joined(separator: "")

        if filtered == string {
            // Check for multiple decimal points
            if string == "." {
                let countDots = textField.text?.components(separatedBy: ".").count ?? 0 - 1
                if countDots == 0 {
                    return true
                } else {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}
