//
//  CardsViewModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import Combine
import UIKit
import PassKit

class CardsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var balance: Double = 0.00
    @Published var isBalanceHidden: Bool = false
    @Published var balanceDisplay: String = "*******"
    @Published var cards: [CardModel] = []
    @Published var options: [OptionModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var lastPaymentWasSuccessful: Bool = false
    
    
    // MARK: - Properties
    
    var selectedCard: CardModel?
    
    private let applePayHandler = ApplePayHandler()
    private let appleWalletHandler = AppleWalletHandler()
    private var cancellables = Set<AnyCancellable>()
    
    var formattedBalanceDisplay: String {
        return isBalanceHidden ? "*******" : String(format: "%.2f SAR", balance)
    }
    
    // MARK: - Initialization
    
    init() {
        fetchCards()
        fetchBalance()
        setupOptions()
        updateAuthToken()
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
    }
    
    func setupOptions() {
        self.options = OptionModel.mockOptions()
    }
    
    func toggleBalanceVisibility() {
        isBalanceHidden.toggle()
    }
    
    // MARK: - Apple Wallet Integration
    
    func addToAppleWallet(card: CardModel, from viewController: UIViewController) {
        let cardHolderName = "John Doe"
        let cardSuffix = String(card.cardNumber.suffix(4))
        
        if appleWalletHandler.isPassKitAvailable() {
            if appleWalletHandler.isCardAdded(cardSuffix: cardSuffix) {
                self.error = WalletError.cardAlreadyAdded
                return
            }
            
            let result = appleWalletHandler.initiateRequest(cardHolderName: cardHolderName, cardSuffix: cardSuffix, from: viewController)
            if !result {
                self.error = WalletError.initiationFailed
            }
        } else {
            self.error = WalletError.appleWalletUnavailable
        }
    }
    
    
    // MARK: - Apple Pay Integration
    
    func payWithApplePay(amount: NSDecimalNumber, from viewController: UIViewController) {
        guard let applePayConfig = ApplePayConfiguration.getConfiguration() else {
            // Handle missing configuration case
            self.error = NSError(domain: "Apple Pay Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Apple Pay not configured. Please call configureApplePay before starting the session."])
            return
        }
        
        // Supported payment networks
        let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex]
        
        applePayHandler.startPayment(
            amount: amount,
            supportedNetworks: supportedNetworks,
            countryCode: applePayConfig.countryCode,
            currencyCode: applePayConfig.currencyCode,
            merchantIdentifier: applePayConfig.merchantId,
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
    }
    
    
    func updateAuthToken() {
        
        let request = UpdateAuthToken(
            grant_type: "client_credentials",
            client_id: "539078621c9a41c8aa370152946cad9a",
            client_secret: "OTcyYjUzMTctNDJiYy00YzRiLWFjMGUtODc5MGUxYzA3YmI3"
        )
        
        Task {
            do {
                self.isLoading = true
                defer { self.isLoading = false }
                
                let result = try await CardAuthService.updateAuthToken(request: request)
                switch result {
                case .success(let tokenResponse):
                    DispatchQueue.main.async {
                        print("updateAuthToken successful: \(tokenResponse)")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("updateAuthToken failed: \(error.localizedDescription)")
                        self.error = error
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error during updateAuthToken: \(error.localizedDescription)")
                    self.error = error
                }
            }
        }
    }
    
}
