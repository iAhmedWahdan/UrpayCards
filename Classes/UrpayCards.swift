//
//  UrpayCards.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 29/09/2024.
//

import UIKit

public class UrpayCards: UIViewController {
    
    @IBOutlet var cardView: UIView!
    
    // Static reference to hold the UIWindow so it doesn't get deallocated
    private static var urpayWindow: UIWindow?
    
    public static func configureTheme(_ config: ThemeConfig) {
        ThemeManager.shared.updateTheme(config: config)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.shared.applyTheme(to: self)
        
        navigationItem.title = ThemeConfig.shared.navigationTitle
        
        // Set up the cardView and start the animation
        setupCardView()
        animateCardView()
    }
    
    private func setupCardView() {
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = .white
        
        // Position the card view off-screen at the top
        cardView.center = CGPoint(x: self.view.center.x, y: -cardView.frame.height)
    }
    
    private func animateCardView() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                self.cardView.center = self.view.center
            },
            completion: nil
        )
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        UrpayCards.stopSession()
    }
    
    public static func startSession() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("No active window scene found")
            return
        }
        
        // Create a new UIWindow and retain it
        urpayWindow = UIWindow(windowScene: windowScene)
        
        // Load the UrpayCards XIB from the bundle
        let viewController = UrpayCards(nibName: "UrpayCards", bundle: Bundle(for: UrpayCards.self))
        let navigationController = NavigationController(rootViewController: viewController)
        
        urpayWindow?.rootViewController = navigationController
        urpayWindow?.makeKeyAndVisible()
    }
    
    public static func stopSession() {
        // Dismiss the window and deallocate it
        urpayWindow?.isHidden = true
        urpayWindow = nil
    }
}
