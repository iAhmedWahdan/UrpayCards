//
//  PaymentMethodsViewModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import Combine
import PassKit

class PaymentMethodsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var methods: [PaymentMethodModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var lastPaymentWasSuccessful: Bool = false
    
    // MARK: - Properties
    
    private let applePayHandler = ApplePayHandler()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        fetchMeyhods()
    }
    
    // MARK: - Methods
    
    func fetchMeyhods() {
        // Fetch or generate methods
        self.methods = PaymentMethodModel.mockMethods()
    }
    
    // MARK: - Apple Pay Integration
    
    func payWithApplePay(amount: NSDecimalNumber, from viewController: UIViewController) {
        let keychain = KeychainHelper.shared
        
        if let merchantIdData = keychain.load(key: "merchantId"),
           let currencyCodeData = keychain.load(key: "currencyCode"),
           let countryCodeData = keychain.load(key: "countryCode"),
           let merchantId = String(data: merchantIdData, encoding: .utf8),
           let currencyCode = String(data: currencyCodeData, encoding: .utf8),
           let countryCode = String(data: countryCodeData, encoding: .utf8) {
            
            // Pass the retrieved values to the view controller
            let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex]
            
            applePayHandler.startPayment(
                amount: amount,
                supportedNetworks: supportedNetworks,
                countryCode: countryCode,
                currencyCode: currencyCode,
                merchantIdentifier: merchantId,
                viewController: viewController
            ) { [weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        // Payment was successful
                        self?.lastPaymentWasSuccessful = true
                    } else {
                        // Payment failed
                        self?.lastPaymentWasSuccessful = false
                        self?.error = error
                    }
                }
            }
        } else {
            // Handle the case where configuration is missing
            self.error = NSError(domain: "Apple Pay Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Apple Pay not configured. Please call configureApplePay before starting the session."])
        }
        
    }
}
