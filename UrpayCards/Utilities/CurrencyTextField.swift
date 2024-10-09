//
//  CurrencyTextField.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import UIKit

class CurrencyTextField: UITextField, UITextFieldDelegate {
    
    // Padding for the text
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 110) // Right padding for currency label
    
    // Currency label displayed on the right
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "SAR" // Set your currency code here
        label.font = UIFont.systemFont(ofSize: 46, weight: .regular)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        return label
    }()
    
    // Store the initial and minimum font sizes for scaling
    private let initialFontSize: CGFloat = 46
    private let minFontSize: CGFloat = 40
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    // MARK: - Setup Method
    private func setupTextField() {
        self.font = UIFont.systemFont(ofSize: initialFontSize, weight: .regular)
        self.textColor = .lightGray
        self.keyboardType = .decimalPad
        self.textAlignment = .right
        self.text = "0"
        
        // Add the currency label
        addSubview(currencyLabel)
        
        // Assign delegate for input validation
        self.delegate = self
        
        // Add target for editing changes
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Layout Adjustments
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCurrencyLabel()
    }
    
    private func layoutCurrencyLabel() {
        let labelWidth: CGFloat = currencyLabel.intrinsicContentSize.width
        currencyLabel.frame = CGRect(x: bounds.width - labelWidth - 16, y: 0, width: labelWidth, height: bounds.height)
    }
    
    // Adjust text rect to include padding for currency label
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // Adjust editing rect to include padding for currency label
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // MARK: - Text Change Handling
    @objc private func textDidChange() {
        guard let text = self.text else { return }
        
        // Remove leading zeros unless the input is less than 1 (e.g., "0.5")
        if text.hasPrefix("0") && text.count > 1 && !text.hasPrefix("0.") {
            self.text = String(text.dropFirst())
        }
        
        adjustFontSize()
        updateTextColor()
    }
    
    private func adjustFontSize() {
        guard let text = self.text else { return }
        let characterCount = text.count
        
        // Adjust font size based on the number of characters
        var newSize = initialFontSize - CGFloat(characterCount - 1) * 2 // Adjust the multiplier as needed
        newSize = max(minFontSize, newSize)
        
        self.font = UIFont.systemFont(ofSize: newSize, weight: .regular)
    }
    
    private func updateTextColor() {
        guard let text = self.text else { return }
        let isPlaceholderText = text.isEmpty || text == "0"
        
        self.textColor = isPlaceholderText ? .lightGray : .white
        self.currencyLabel.textColor = isPlaceholderText ? .lightGray : .white
    }
    
    // MARK: - Input Validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow deletion
        if string.isEmpty {
            return true
        }
        
        // Define allowed characters (digits and decimal point)
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        
        // Check if the input characters are allowed
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // Get the updated text after the proposed change
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        // Allow only one decimal point
        let decimalCount = updatedText.components(separatedBy: ".").count - 1
        if decimalCount > 1 {
            return false
        }
        
        // Limit total number of characters if needed
        let maxLength = 10 // Set your maximum length
        if updatedText.count > maxLength {
            return false
        }
        
        // Optional: Limit the number of digits after the decimal point
        if let decimalIndex = updatedText.firstIndex(of: ".") {
            let afterDecimal = updatedText[updatedText.index(after: decimalIndex)...]
            let maxDecimalPlaces = 2 // Set your maximum decimal places
            if afterDecimal.count > maxDecimalPlaces {
                return false
            }
        }
        
        return true
    }
}
