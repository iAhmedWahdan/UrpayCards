//
//  CurrencyLabel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import UIKit

class CurrencyLabel: UILabel {
    
    // Custom initializer for the label
    init(frame: CGRect, amount: Double, currency: String) {
        super.init(frame: frame)
        self.formatText(amount: amount, currency: currency)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Set a default amount and currency if needed
        self.formatText(amount: 0.0, currency: "SAR")
    }
    
    // Function to format the label's text
    private func formatText(amount: Double, currency: String) {
        let theme = ThemeManager.shared.config
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        
        let fullText = "\(formattedAmount) \(currency)"
        
        // Create mutable attributed string
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // Find the location of the decimal point
        if let decimalRange = formattedAmount.range(of: ".") {
            let mainPartLength = formattedAmount.distance(from: formattedAmount.startIndex, to: decimalRange.lowerBound)
            
            // Define attributes for the main part (before the decimal point)
            let mainAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 42, weight: .semibold), // Larger font for the number
                .foregroundColor: theme.secondaryColor ?? UIColor.white // White color for the text
            ]
            
            // Define attributes for the smaller part (decimals and currency)
            let smallerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .semibold), // Smaller font for decimals and currency
                .foregroundColor: theme.secondaryColor ?? UIColor.white // Light gray color for the smaller part
            ]
            
            // Apply the main attributes to the number part
            attributedText.addAttributes(mainAttributes, range: NSRange(location: 0, length: mainPartLength))
            
            // Apply the smaller attributes to the decimal and currency part
            let decimalStartIndex = mainPartLength
            let decimalLength = fullText.count - decimalStartIndex
            attributedText.addAttributes(smallerAttributes, range: NSRange(location: decimalStartIndex, length: decimalLength))
        }

        // Set the label's attributed text
        self.attributedText = attributedText
        self.textAlignment = .center // Optional: Align text in the center
    }
    
    // Convenience function to update the label
    func updateAmount(_ amount: Double, currency: String) {
        formatText(amount: amount, currency: currency)
    }
}
