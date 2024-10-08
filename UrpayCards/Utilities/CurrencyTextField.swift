//
//  CurrencyTextField.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import UIKit

class CurrencyTextField: UITextField {

    // Padding for the text
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 110) // right padding for currency label

    // Currency label that will be displayed on the right
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "SAR"
        label.font = UIFont.systemFont(ofSize: 46, weight: .regular)
        label.textColor = UIColor.lightGray // Ensure contrast in dark mode
        label.sizeToFit()
        return label
    }()

    // Store the initial font size for scaling
    private let initialFontSize: CGFloat = 46
    private let minFontSize: CGFloat = 40

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }

    private func setupTextField() {
        self.font = UIFont.systemFont(ofSize: initialFontSize, weight: .regular) // Large font initially
        self.textColor = .lightGray
        self.keyboardType = .numberPad
        self.textAlignment = .right
        self.text = "0"
        
        // Add the currency label
        addSubview(currencyLabel)

        // Add target for editing changes
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

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

    @objc private func textDidChange() {
        guard var text = self.text else { return }

        // Animate font size based on the number of digits entered
        let characterCount = text.count
        
        if text.first == "0" && characterCount > 1 {
            text.removeFirst()
            self.text = text
        }
        
        if characterCount == 0 {
            self.font = UIFont.systemFont(ofSize: initialFontSize, weight: .regular)
            self.text = "0"
        } else if characterCount > 6 {
            animateFontSize(to: minFontSize)
        } else {
            let scale = CGFloat(1 - (Double(characterCount) / 10.0))
            let newSize = max(minFontSize, initialFontSize * scale)
            animateFontSize(to: newSize)
        }
        
        self.textColor = characterCount == 0 ? .lightGray : .white
        self.currencyLabel.textColor = characterCount == 0 ? .lightGray : .white
        
        self.textAlignment = .right
    }

    private func animateFontSize(to size: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.font = UIFont.systemFont(ofSize: self.initialFontSize, weight: .regular)
        }
    }
}
