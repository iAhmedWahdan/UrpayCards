//
//  AmountViewController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import UIKit

class AmountViewController: BaseViewController {
    
    @IBOutlet var amountTextField: CurrencyTextField!

    var completionHandler: ((_ amount: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Amount"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        amountTextField.becomeFirstResponder()
    }

    @IBAction func doneTapped() {
        self.completionHandler?(amountTextField.text ?? "")
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Override the transitioning delegate method

extension AmountViewController {
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
