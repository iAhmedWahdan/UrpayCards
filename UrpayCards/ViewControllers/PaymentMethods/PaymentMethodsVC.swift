//
//  PaymentMethodsVC.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import UIKit

class PaymentMethodsVC: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel = PaymentMethodsViewModel()
    
    var completionHandler: ((_ method: PaymentMethodModel) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMethods()
        configureTableView()
    }
    
    override func setupUI() {
        super.setupUI()
        applyTheme()
        configureTableView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        bindMethods()
        bindPaymentStatus()
    }
    
    // MARK: - UI Configuration
    
    private func applyTheme() {
        // Apply the current theme to UI elements
        let theme = ThemeManager.shared.config
        ThemeManager.shared.applyTheme(to: self)
        // Apply theme to other UI elements as needed
        view.backgroundColor = theme.backgroundColor
    }
    
    private func bindMethods() {
        viewModel.$methods
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindError() {
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }
    
    private func bindLoading() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &cancellables)
    }
    
    private func bindPaymentStatus() {
        viewModel.$lastPaymentWasSuccessful
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                guard let self = self else { return }
                if success {
                    showAlert(title: "Payment Successful", message: "Your payment was processed successfully.")
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let frameworkBundle = Bundle(for: UrpayCardsSDK.self)
        
        tableView.register(
            UINib(nibName: PaymentMethodCell.className, bundle: frameworkBundle),
            forCellReuseIdentifier: PaymentMethodCell.className
        )
    }
    
}

extension PaymentMethodsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.methods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCell.className, for: indexPath) as! PaymentMethodCell
        let method = viewModel.methods[indexPath.row]
        cell.configure(with: method)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let method = viewModel.methods[indexPath.row]
        switch method.type {
        case .bankCard:
            print("bank card")
        case .accountDetails:
            print("account details")
        case .cashDeposit:
            print("cash deposit")
        case .applePay:
            dismiss(animated: true) { [weak self] in
                guard let self else { return }
                self.completionHandler?(method)
            }
        }
    }
    
    func showApplePay() {
        //        let amount = NSDecimalNumber(string: "10.00") // Replace with the actual amount
        //        viewModel.payWithApplePay(amount: amount, from: self)
        if let amountViewController = instantiateViewController(storyboardName: "Cards", viewControllerClass: AmountViewController.self) {
            presentViewController(amountViewController, withCustomPresentation: true)
        }
    }
}

// MARK: - Override the transitioning delegate method

extension PaymentMethodsVC {
    override func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let slideUpPresentationController = SlideUpPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        // Configure properties specific to PaymentMethodsVC
        slideUpPresentationController.handleViewSize = .init(width: 80, height: 4)
        slideUpPresentationController.handleViewColor = .c515151
        slideUpPresentationController.cornerRadius = 25
        return slideUpPresentationController
    }
    
}
