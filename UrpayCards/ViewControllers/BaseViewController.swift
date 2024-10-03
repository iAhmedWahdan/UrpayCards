//
//  BaseViewController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import UIKit
import Combine

public class BaseViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Method to configure the theme using the ThemeManager
    public func configureTheme(_ config: ThemeConfig) {
        ThemeManager.shared.updateTheme(config: config)
        ThemeManager.shared.applyTheme(to: self)
    }
    
    // Session management methods
    public static var urpayWindow: UIWindow?
    
    // Allow starting session without requiring a theme
    public static func startSession(storyboardName: String = "Cards", viewControllerIdentifier: String = "UrpayCards") {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("No active window scene found")
            return
        }
        
        urpayWindow = UIWindow(windowScene: windowScene)
        let bundle = Bundle(for: BaseViewController.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? BaseViewController {
            let navigationController = NavigationController(rootViewController: viewController)
            urpayWindow?.rootViewController = navigationController
            urpayWindow?.makeKeyAndVisible()
        } else {
            print("Failed to instantiate view controller with identifier \(viewControllerIdentifier)")
        }
    }
    
    public static func stopSession() {
        urpayWindow?.isHidden = true
        urpayWindow = nil
    }
    
    // Method to clean up Combine subscriptions
    public func cancelSubscriptions() {
        cancellables.removeAll()
    }
}
