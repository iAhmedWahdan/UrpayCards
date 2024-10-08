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
    
    // Loading indicator management
    var isLoading: Bool = false {
        didSet {
            updateLoadingIndicator()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        // Set up default UI elements here
    }
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        // Bind to ViewModel properties here
    }
    
    // MARK: - Loading Indicator
    
    private func updateLoadingIndicator() {
        if isLoading {
            // Show loading indicator
        } else {
            // Hide loading indicator
        }
    }
    
    // MARK: - Error Handling
    
    func handleError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Alert Handling
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Combine Subscriptions
    
    deinit {
        cancelSubscriptions()
    }
    
    public func cancelSubscriptions() {
        cancellables.removeAll()
    }
}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    
    // MARK: - Instantiate View Controller
    
    func instantiateViewController<T: UIViewController>(storyboardName: String, viewControllerClass: T.Type) -> T? {
        let bundle = Bundle(for: viewControllerClass)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let identifier = String(describing: viewControllerClass)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            return viewController
        } else {
            print("Failed to instantiate \(identifier) from storyboard \(storyboardName)")
            return nil
        }
    }
    
    // MARK: - Present View Controller
    
    func presentViewController(_ viewController: UIViewController, withCustomPresentation: Bool = false) {
        if withCustomPresentation {
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self
        }
        self.present(viewController, animated: true)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let slideUpPresentationController = SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
        // Configure properties if needed
        slideUpPresentationController.allowsDismissing = true
        return slideUpPresentationController
    }
    
}
