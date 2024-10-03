//
//  UrpayCardsViewModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import Combine

class UrpayCardsViewModel: ObservableObject {
    
    // Published properties to bind with the view controller
    @Published var balance: Double = 0.00
    @Published var isBalanceHidden: Bool = true
    @Published var balanceDisplay: String = "*******" // Initially hidden
    @Published var cards: [CardModel] = []
    @Published var options: [OptionModel] = OptionModel.mockOptions()
    
    let appleWalletHandler = AppleWalletHandler()
    
    init() {
        // Fetch initial data here if needed
        fetchCards()
        fetchBalance()
    }
    
    func fetchCards() {
        self.cards = CardModel.mockData()
        self.options = OptionModel.mockOptions()
    }
    
    func fetchBalance() {
        // Fetch or simulate balance
        self.balance = 9175.99
        updateBalanceDisplay()
    }
    
    func toggleBalanceVisibility() {
        isBalanceHidden.toggle()
        updateBalanceDisplay()
    }
    
    private func updateBalanceDisplay() {
        if isBalanceHidden {
            balanceDisplay = "*******"
        } else {
            balanceDisplay = String(format: "%.2f", balance)
        }
    }
    
    func addToAppleWallet(from viewController: UIViewController) {
        print("Adding card to Apple Wallet...")
        let cardHolderName = "John Doe"
        let cardSuffix = "1234"
        
        if appleWalletHandler.isPassKitAvailable() {
            let result = appleWalletHandler.initiateRequest(cardHolderName: cardHolderName, cardSuffix: cardSuffix, from: viewController)
            if !result {
                print("Failed to initiate Apple Wallet request.")
            }
        } else {
            print("Apple Wallet is not available on this device.")
        }
    }
}
