//
//  AlertHelper.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 10/10/2024.
//

import UIKit

class AlertHelper {
    static func showAlert(on viewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            viewController.dismiss(animated: true, completion: nil)
            completion?()
        })
        viewController.present(alertController, animated: true, completion: nil)
    }
}
