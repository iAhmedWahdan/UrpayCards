//
//  ThemeConfig.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit

public struct ThemeConfig {
    public static let shared = ThemeConfig()
    
    public var navigationBarColor: UIColor?
    public var navigationBarColor2: UIColor?
    public var backgroundColor: UIColor?
    public var backgroundColor2: UIColor?
    public var priamryColor: UIColor?
    public var secondaryColor: UIColor?
    public var titleTextColor: UIColor
    public var cardBackgroundColor: UIColor?
    public var navigationBarFont: UIFont
    public var navigationTitle: String

    // Initialize with default values
    public init(
        navigationBarColor: UIColor? = nil,
        navigationBarColor2: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        backgroundColor2: UIColor? = nil,
        priamryColor: UIColor? = nil,
        secondaryColor: UIColor? = nil,
        titleTextColor: UIColor = .white,
        cardBackgroundColor: UIColor? = nil,
        navigationBarFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold),
        navigationTitle: String = "Urpay Cards"
    ) {
        self.navigationBarColor = navigationBarColor
        self.navigationBarColor2 = navigationBarColor2
        self.backgroundColor = backgroundColor
        self.backgroundColor2 = backgroundColor2
        self.priamryColor = priamryColor
        self.secondaryColor = secondaryColor
        self.titleTextColor = titleTextColor
        self.cardBackgroundColor = cardBackgroundColor
        self.navigationBarFont = navigationBarFont
        self.navigationTitle = navigationTitle
    }
}
