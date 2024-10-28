//
//  SecondaryLabel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 22/10/2024.
//

import UIKit

class SecondaryLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let theme = ThemeManager.shared.config
        textColor = theme.secondaryColor ?? .white
    }
    
}
