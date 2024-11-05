//
//  VPNProxyDetection.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 17/10/2024.
//

import Network
import UIKit

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isSecurityViewControllerPresented = false
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    if self.isUsingVPN() || self.isUsingProxy() {
                        self.showSecurityViewController()
                    } else {
                        self.dismissSecurityViewController()
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func isUsingVPN() -> Bool {
        let cfDict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any]
        if let proxies = cfDict?["__SCOPED__"] as? [String: Any] {
            for key in proxies.keys {
                if key.contains("tap") || key.contains("tun") || key.contains("ppp") {
                    return true
                }
            }
        }
        return false
    }
    
    private func isUsingProxy() -> Bool {
        if let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
           let httpProxy = proxySettings["HTTPProxy"] as? String, !httpProxy.isEmpty {
            return true
        }
        return false
    }
    
    // Present the SecurityViewController in fullscreen
    private func showSecurityViewController() {
        guard let topViewController = getTopViewController(),
              !isSecurityViewControllerPresented else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Cards", bundle: .urpayCardsResources)
        if let securityVC = storyboard.instantiateViewController(withIdentifier: "SecurityViewController") as? SecurityViewController {
            securityVC.modalPresentationStyle = .fullScreen
            topViewController.present(securityVC, animated: true, completion: nil)
            isSecurityViewControllerPresented = true
        }
    }
    
    // Dismiss SecurityViewController if it's presented
    private func dismissSecurityViewController() {
        guard isSecurityViewControllerPresented,
              let topViewController = getTopViewController() else {
            return
        }
        
        topViewController.dismiss(animated: true, completion: {
            self.isSecurityViewControllerPresented = false
        })
    }
    
    // Helper function to get the topmost UIViewController
    private func getTopViewController() -> UIViewController? {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            var topController = keyWindow.rootViewController
            while let presentedViewController = topController?.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
