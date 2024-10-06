//
//  UrpayCardsSDK.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 06/10/2024.
//

import UIKit

public class UrpayCardsSDK {

    public static var urpayWindow: UIWindow?
    
    // Static properties to store the Apple Pay configuration
    private static var merchantId: String?
    private static var currencyCode: String?
    private static var countryCode: String?

    public static func startSession() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("No active window scene found")
            return
        }

        urpayWindow = UIWindow(windowScene: windowScene)
        let bundle = Bundle(for: UrpayCardsViewController.self)
        let storyboard = UIStoryboard(name: "Cards", bundle: bundle)

        if let viewController = storyboard.instantiateViewController(withIdentifier: "UrpayCardsViewController") as? UrpayCardsViewController {
            let navigationController = NavigationController(rootViewController: viewController)
            urpayWindow?.rootViewController = navigationController
            urpayWindow?.makeKeyAndVisible()
        } else {
            print("Failed to instantiate UrpayCardsViewController")
        }
    }

    public static func stopSession() {
        urpayWindow?.isHidden = true
        urpayWindow = nil
        clearApplePayConfiguration()
    }

    public static func configureTheme(_ config: ThemeConfig) {
        ThemeManager.shared.updateTheme(config: config)
    }
    
    public static func configureApplePay(merchantId: String, currencyCode: String, countryCode: String) {
        let keychain = KeychainHelper.shared
        
        // Convert strings to Data
        if let merchantIdData = merchantId.data(using: .utf8),
           let currencyCodeData = currencyCode.data(using: .utf8),
           let countryCodeData = countryCode.data(using: .utf8) {
            
            // Save to Keychain
            _ = keychain.save(key: "merchantId", data: merchantIdData)
            _ = keychain.save(key: "currencyCode", data: currencyCodeData)
            _ = keychain.save(key: "countryCode", data: countryCodeData)
        } else {
            print("Error converting configuration strings to Data.")
        }
    }
    
    public static func clearApplePayConfiguration() {
        let keychain = KeychainHelper.shared
        _ = keychain.delete(key: "merchantId")
        _ = keychain.delete(key: "currencyCode")
        _ = keychain.delete(key: "countryCode")
    }

}
