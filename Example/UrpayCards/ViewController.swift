//
//  ViewController.swift
//  UrpayCards
//
//  Created by iAhmedWahdan on 09/29/2024.
//  Copyright (c) 2024 iAhmedWahdan. All rights reserved.
//

import UIKit
import UrpayCards

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTheme()
    }
    
    func configureTheme() {
        let customTheme = ThemeConfig(
            navigationBarColor: UIColor.c292929,
            backgroundColor: UIColor.c151515,
            titleTextColor: .white,
            cardBackgroundColor: .lightGray,
            font: UIFont.systemFont(ofSize: 16),
            navigationBarFont: UIFont.systemFont(ofSize: 18, weight: .bold),
            statusTextColor: .red,
            navigationTitle: "Cards"
        )
        
        // Apply the custom theme
        UrpayCards.configureTheme(customTheme)
    }
    
    @IBAction func didTapPayButton(_ sender: Any) {
        UrpayCards.startSession()
    }
    
}

