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
        viewController.view.backgroundColor = config.backgroundColor
        self.setNavigationBarColor(viewController: viewController)
    }
    
    func setNavigationBarColor(viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = config.navigationBarColor
        appearance.shadowColor = .clear
        
        // Title text attributes
        var titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: config.titleTextColor
        ]
        titleAttributes[.font] = config.navigationBarFont
        
        appearance.titleTextAttributes = titleAttributes
        appearance.largeTitleTextAttributes = titleAttributes
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.tintColor = config.titleTextColor
        navigationController.navigationBar.prefersLargeTitles = false
    }
}
