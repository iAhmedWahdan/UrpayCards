//
//  SecurityViewController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 17/10/2024.
//

import UIKit

class SecurityViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        applyTheme()
    }
    
    // MARK: - UI Configuration
    
    private func applyTheme() {
        ThemeManager.shared.applyTheme(to: self)
    }

}
