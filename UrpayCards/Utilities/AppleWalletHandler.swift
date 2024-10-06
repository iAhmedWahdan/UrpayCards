//
//  AppleWalletHandler.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import PassKit
import UIKit

// Define a typealias to handle the completion process
typealias CompletedPaymentProcessHandler = (PKAddPaymentPassRequest) -> Void

class AppleWalletHandler: NSObject, PKAddPaymentPassViewControllerDelegate {
    
    var completionHandler: CompletedPaymentProcessHandler?
    
    // Method to initiate Apple Wallet request
    func initiateRequest(cardHolderName: String, cardSuffix: String, from viewController: UIViewController) -> Bool {
        guard let configuration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .RSA_V2) else {
            return false
        }
        
        configuration.cardholderName = cardHolderName
        configuration.primaryAccountSuffix = cardSuffix
        configuration.primaryAccountIdentifier = getPrimaryAccountIdentifier(cardSuffix)
        
        // Present the Apple Wallet Add Pass View Controller
        guard let enrollViewController = PKAddPaymentPassViewController(requestConfiguration: configuration, delegate: self) else {
            return false
        }
        
        DispatchQueue.main.async {
            viewController.present(enrollViewController, animated: true, completion: nil)
        }
        return true
    }
    
    // Check if PassKit is available
    func isPassKitAvailable() -> Bool {
        return PKAddPaymentPassViewController.canAddPaymentPass()
    }
    
    // Check if the card is already added to Apple Wallet
    func isCardAdded(cardSuffix: String) -> Bool {
        let passLibrary = PKPassLibrary()
        let paymentPasses = passLibrary.passes(of: .payment)
        
        return paymentPasses.contains { $0.paymentPass?.primaryAccountNumberSuffix == cardSuffix }
    }
    
    // MARK: - PKAddPaymentPassViewControllerDelegate
    
    func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController, generateRequestWithCertificateChain certificates: [Data], nonce: Data, nonceSignature: Data, completionHandler handler: @escaping (PKAddPaymentPassRequest) -> Void) {
        
        self.completionHandler = handler
        
        // Normally here you'd send certificates to your server to generate the pass data
        let passRequest = PKAddPaymentPassRequest()
        
        // Provide the encrypted card data from your server (example values)
        passRequest.encryptedPassData = Data() // Add your actual encrypted pass data here
        passRequest.activationData = Data() // Activation data (optional)
        passRequest.ephemeralPublicKey = Data() // Ephemeral public key (optional)
        passRequest.wrappedKey = Data() // Wrapped key (optional)
        
        // Call the handler with the filled request
        handler(passRequest)
    }
    
    func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController, didFinishAdding pass: PKPaymentPass?, error: Error?) {
        controller.dismiss(animated: true) {
            if let error = error {
                print("Failed to add payment pass: \(error.localizedDescription)")
                // Optionally notify the ViewModel of the error
            } else {
                print("Payment pass added successfully!")
                // Optionally notify the ViewModel of the success
            }
        }
    }
    
    // Helper function to get the primary account identifier from Apple Wallet
    private func getPrimaryAccountIdentifier(_ suffix: String) -> String {
        let passLibrary = PKPassLibrary()
        let paymentPasses = passLibrary.passes(of: .payment)
        let desiredPasses = paymentPasses.filter { $0.paymentPass?.primaryAccountNumberSuffix == suffix }
        if let pass = desiredPasses.first {
            return pass.paymentPass?.primaryAccountIdentifier ?? ""
        }
        return ""
    }
}
