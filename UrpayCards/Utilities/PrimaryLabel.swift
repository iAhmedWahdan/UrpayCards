//
//  PrimaryLabel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 22/10/2024.
//

import UIKit

class PrimaryLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let theme = ThemeManager.shared.config
        textColor = theme.priamryColor ?? .cAE926A
    }
    
}
