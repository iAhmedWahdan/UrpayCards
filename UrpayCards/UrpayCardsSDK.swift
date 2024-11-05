//
//  UrpayCardsSDK.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 06/10/2024.
//

import UIKit

public class UrpayCardsSDK {
    
    public static var urpayWindow: UIWindow?
    
    private static let networkMonitor = NetworkMonitor()
    
    public static func getCardsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Cards", bundle: .urpayCardsResources)
    }
    
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
        
        if let viewController = getCardsStoryboard().instantiateViewController(withIdentifier: "CardsViewController") as? CardsViewController {
            let navigationController = NavigationController(rootViewController: viewController)
            urpayWindow?.rootViewController = navigationController
            urpayWindow?.makeKeyAndVisible()
        } else {
            print("Failed to instantiate CardsViewController")
        }
        
        // Start monitoring for VPN/Proxy and handle SecurityViewController
        networkMonitor.startMonitoring()
    }
    
    public static func stopSession() {
        networkMonitor.stopMonitoring()
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
