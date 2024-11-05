//
//  PaymentMethodCell.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    func configure(with paymentMethod: PaymentMethodModel) {
        nameLabel.text = paymentMethod.title

        if let image = UIImage(named: paymentMethod.imageName, in: .urpayCardsResources, compatibleWith: nil) {
            iconImageView.image = image
        } else {
            // Optional: You can log if the image is not found for debugging purposes
            print("Image not found for name: \(paymentMethod.imageName)")
            iconImageView.image = nil // Or a fallback image
        }
    }
}
