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
        configureApplePay()
    }
    
    func configureTheme() {
        let customTheme = ThemeConfig(
            navigationBarColor: UIColor.c151515,
            navigationBarColor2: UIColor.c292929,
            backgroundColor: UIColor.c151515,
            backgroundColor2: UIColor.c292929,
            priamryColor: UIColor.cAE926A,
            secondaryColor: UIColor.white,
            titleTextColor: .white,
            cardBackgroundColor: .c292929,
            navigationBarFont: UIFont.systemFont(ofSize: 18, weight: .bold),
            navigationTitle: "Cards"
        )
        
        // Apply the custom theme
        UrpayCardsSDK.configureTheme(customTheme)
    }
    
    func configureApplePay() {
        UrpayCardsSDK.configureApplePay(
            merchantId: "merchant.com.urpay.cardsSDK",
            currencyCode: "SAR",
            countryCode: "SA"
        )
    }
    
    @IBAction func didTapPayButton(_ sender: Any) {
        UrpayCardsSDK.startSession()
    }
    
}

