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
