//
//  NavigationController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit

public class NavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Apply the theme to the navigation controller
        applyTheme()
    }

    private func applyTheme() {
        // Customize the navigation bar based on the ThemeManager
        let theme = ThemeManager.shared.config
        navigationBar.prefersLargeTitles = false
        
        let titleTextAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: theme.titleTextColor,
            .font: theme.navigationBarFont
        ]
        
        let largeTitleTextAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: theme.titleTextColor,
            .font: theme.navigationBarFont
        ]
        navigationBar.tintColor = theme.titleTextColor
        
        let standardAppearance = navigationBar.standardAppearance
        let scrollEdgeAppearance = navigationBar.scrollEdgeAppearance ?? UINavigationBarAppearance()
                                
        standardAppearance.titleTextAttributes = titleTextAttributes
        standardAppearance.largeTitleTextAttributes = largeTitleTextAttributes
        standardAppearance.backgroundColor = theme.navigationBarColor
        standardAppearance.shadowColor = .clear
        
        scrollEdgeAppearance.titleTextAttributes = titleTextAttributes
        scrollEdgeAppearance.largeTitleTextAttributes = largeTitleTextAttributes
        scrollEdgeAppearance.backgroundColor = theme.navigationBarColor
        scrollEdgeAppearance.shadowColor = .clear
        
        navigationBar.standardAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
}

extension NavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewControllers.forEach { vc in
            vc.navigationItem.backBarButtonItem = emptyBackButtonItem
        }
    }
    
    var emptyBackButtonItem: UIBarButtonItem {
        let item = UIBarButtonItem()
        item.title = ""
        return item
    }
}
