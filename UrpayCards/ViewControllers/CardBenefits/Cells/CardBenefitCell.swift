//
//  CardBenefitCell.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 10/10/2024.
//

import UIKit

class CardBenefitCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    func configure(with benefit: CardBenefitModel) {
        titleLabel.text = benefit.title
        descriptionLabel.text = benefit.description
    }
    
}
