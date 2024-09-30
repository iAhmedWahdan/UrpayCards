//
//  ThemeConfig.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit

public struct ThemeConfig {
    public static let shared = ThemeConfig()
    
    public var navigationBarColor: UIColor
    public var backgroundColor: UIColor
    public var titleTextColor: UIColor
    public var cardBackgroundColor: UIColor
    public var font: UIFont
    public var navigationBarFont: UIFont
    public var statusTextColor: UIColor
    public var navigationTitle: String

    // Initialize with default values
    public init(
        navigationBarColor: UIColor = .systemBlue,
        backgroundColor: UIColor = .white,
        titleTextColor: UIColor = .white,
        cardBackgroundColor: UIColor = .systemBlue,
        font: UIFont = UIFont.systemFont(ofSize: 16),
        navigationBarFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold),
        statusTextColor: UIColor = .green,
        navigationTitle: String = "Urpay Cards"
    ) {
        self.navigationBarColor = navigationBarColor
        self.backgroundColor = backgroundColor
        self.titleTextColor = titleTextColor
        self.cardBackgroundColor = cardBackgroundColor
        self.font = font
        self.navigationBarFont = navigationBarFont
        self.statusTextColor = statusTextColor
        self.navigationTitle = navigationTitle
    }
}
