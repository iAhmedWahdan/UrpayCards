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
    
    private var loadingIndicatorView: LoadingIndicatorView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK:- UI Setup
    
    func setupUI() {
        // Set up default UI elements here
    }
    
    // MARK:- Navigation Bar Appearance
    
    func setNavigationBarColor(_ color: UIColor,
                               titleTextColor: UIColor = .white,
                               titleFont: UIFont? = nil,
                               prefersLargeTitles: Bool = false) {
        guard let navigationController = self.navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        
        // Title text attributes
        var titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleTextColor
        ]
        if let titleFont = titleFont {
            titleAttributes[.font] = titleFont
        }
        
        appearance.titleTextAttributes = titleAttributes
        appearance.largeTitleTextAttributes = titleAttributes
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.tintColor = titleTextColor
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
    }
    
    // MARK:- ViewModel Binding
    
    func bindViewModel() {
        // Bind to ViewModel properties here
    }
    
    // MARK:- Loading Indicator
    
    private func updateLoadingIndicator() {
        if isLoading {
            showLoadingIndicator()
        } else {
            hideLoadingIndicator()
        }
    }
    
    func showLoadingIndicator() {
        let spinner = LoadingSpinner.show(title: "Loading...")
        spinner.innerColor = .white
        spinner.outerColor = .cB59064
    }
    
    func hideLoadingIndicator() {
        LoadingSpinner.hide()
    }
    
    // MARK:- Error Handling
    
    func handleError(_ error: Error) {
        AMToaster.toast(error, type: .error)
    }
    
    // MARK:- Alert Handling
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK:- Combine Subscriptions
    
    deinit {
        cancelSubscriptions()
    }
    
    public func cancelSubscriptions() {
        cancellables.removeAll()
    }
}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    
    // MARK:- Instantiate View Controller
    
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
    
    // MARK:- Present View Controller
    
    func presentViewController(_ viewController: UIViewController, withCustomPresentation: Bool = false) {
        if withCustomPresentation {
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self
        }
        self.present(viewController, animated: true)
    }
    
    // MARK:- UIViewControllerTransitioningDelegate
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let slideUpPresentationController = SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
        // Configure properties if needed
        slideUpPresentationController.allowsDismissing = true
        return slideUpPresentationController
    }
    
}
