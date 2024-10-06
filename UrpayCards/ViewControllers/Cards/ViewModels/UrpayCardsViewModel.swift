//
//  UrpayCardsViewModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import Combine
import UIKit
import PassKit

class UrpayCardsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var balance: Double = 0.00
    @Published var isBalanceHidden: Bool = false
    @Published var balanceDisplay: String = "*******"
    @Published var cards: [CardModel] = []
    @Published var options: [OptionModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var lastPaymentWasSuccessful: Bool = false
    var selectedCard: CardModel?
    
    // MARK: - Properties
    
    private let appleWalletHandler = AppleWalletHandler()
    private let applePayHandler = ApplePayHandler()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        fetchCards()
        fetchBalance()
        setupOptions()
    }
    
    // MARK: - Methods
    
    func fetchCards() {
        // Fetch or generate cards
        self.cards = CardModel.mockData()
        self.selectedCard = cards.first
    }
    
    func fetchBalance() {
        // Fetch or simulate balance
        self.balance = 9175.99
        updateBalanceDisplay()
    }
    
    func setupOptions() {
        self.options = OptionModel.mockOptions()
    }
    
    func toggleBalanceVisibility() {
        isBalanceHidden.toggle()
        updateBalanceDisplay()
    }
    
    private func updateBalanceDisplay() {
        if isBalanceHidden {
            balanceDisplay = "*******"
        } else {
            balanceDisplay = String(format: "%.2f SAR", balance)
        }
    }
    
    // MARK: - Apple Wallet Integration
    
    func addToAppleWallet(card: CardModel, from viewController: UIViewController) {
        let cardHolderName = "John Doe"
        let cardSuffix = String(card.cardNumber.suffix(4))
        
        if appleWalletHandler.isPassKitAvailable() {
            // Check if the card is already added
            if appleWalletHandler.isCardAdded(cardSuffix: cardSuffix) {
                self.error = NSError(domain: "AppleWalletError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Card is already added to Apple Wallet."])
                return
            }
            let result = appleWalletHandler.initiateRequest(cardHolderName: cardHolderName, cardSuffix: cardSuffix, from: viewController)
            if !result {
                // Handle failure to initiate request
                self.error = NSError(domain: "AppleWalletError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to initiate Apple Wallet request."])
            }
        } else {
            // Handle Apple Wallet not available
            self.error = NSError(domain: "AppleWalletError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Apple Wallet is not available on this device."])
        }
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
