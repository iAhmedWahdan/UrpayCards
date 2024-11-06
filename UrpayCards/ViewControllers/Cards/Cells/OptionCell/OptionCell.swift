//
//  OptionCell.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 02/10/2024.
//

import UIKit

class OptionCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    func configure(with option: OptionModel) {
        nameLabel.text = option.title
        
        if let image = UIImage(named: option.imageName, in: .urpayCardsAssets, compatibleWith: nil) {
            iconImageView.image = image
        } else {
            // Optional: You can log if the image is not found for debugging purposes
            print("Image not found for name: \(option.imageName)")
            iconImageView.image = nil // Or a fallback image
        }
    }
}
