//
//  ApplePayHandler.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 06/10/2024.
//

import Foundation
import PassKit
import UIKit

class ApplePayHandler: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    
    typealias PaymentCompletionHandler = (Bool, Error?) -> Void
    
    private var paymentCompletionHandler: PaymentCompletionHandler?
    
    func startPayment(
        amount: NSDecimalNumber,
        supportedNetworks: [PKPaymentNetwork],
        countryCode: String,
        currencyCode: String,
        merchantIdentifier: String,
        viewController: UIViewController,
        completion: @escaping PaymentCompletionHandler
    ) {
        self.paymentCompletionHandler = completion
        
        guard PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) else {
            completion(false, NSError(domain: "ApplePay", code: 1, userInfo: [NSLocalizedDescriptionKey: "Apple Pay is not available or no supported cards are set up."]))
            return
        }
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantIdentifier
        paymentRequest.supportedNetworks = supportedNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = countryCode
        paymentRequest.currencyCode = currencyCode
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Total", amount: amount)
        ]
        
        guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {
            completion(false, NSError(domain: "ApplePay", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to present Apple Pay authorization."]))
            return
        }
        paymentVC.delegate = self
        
        DispatchQueue.main.async {
            print(viewController.className)
            viewController.present(paymentVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Process the payment with your server or payment gateway
        processPayment(payment) { (success, error) in
            if success {
                let result = PKPaymentAuthorizationResult(status: .success, errors: nil)
                completion(result)
                self.paymentCompletionHandler?(true, nil)
            } else {
                let result = PKPaymentAuthorizationResult(status: .failure, errors: [error].compactMap { $0 })
                completion(result)
                self.paymentCompletionHandler?(false, error)
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Payment Processing
    
    private func processPayment(_ payment: PKPayment, completion: @escaping (Bool, Error?) -> Void) {
        // Extract the payment token
        let paymentToken = payment.token
        
        // Convert paymentToken.paymentData to a format your server can accept
        let paymentData = paymentToken.paymentData
        
        // Create a URLRequest to your server's payment processing endpoint
        var request = URLRequest(url: URL(string: "https://yourserver.com/processPayment")!) // Replace with your server URL
        request.httpMethod = "POST"
        request.httpBody = paymentData
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        // Send the payment data to your server
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            // Parse the response from your server
            // For this example, we'll assume the payment was successful
            completion(true, nil)
        }
        task.resume()
    }
}
