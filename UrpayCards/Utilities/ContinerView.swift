//
//  ContinerView.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 22/10/2024.
//

import UIKit

class ContinerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        let theme = ThemeManager.shared.config
        backgroundColor = theme.backgroundColor2 ?? .c292929
    }
}
