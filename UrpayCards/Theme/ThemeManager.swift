//
//  ThemeManager.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit

internal class ThemeManager {
    static let shared = ThemeManager()

    // Hold the current theme configuration
    private(set) var config: ThemeConfig

    private init(config: ThemeConfig = ThemeConfig()) {
        self.config = config
    }

    // Method to update the current theme configuration
    func updateTheme(config: ThemeConfig) {
        self.config = config
    }

    // Apply the theme to a view controller
    func applyTheme(to viewController: UIViewController) {
        viewController.navigationItem.title = config.navigationTitle
        viewController.view.backgroundColor = config.backgroundColor
        viewController.navigationController?.navigationBar.barTintColor = config.navigationBarColor
        viewController.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: config.titleTextColor,
            NSAttributedString.Key.font: config.navigationBarFont
        ]
    }
}
