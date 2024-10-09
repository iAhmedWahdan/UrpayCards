//
//  CardSettingsVC.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 09/10/2024.
//

import UIKit

class CardSettingsVC: BaseViewController {
    
    @IBOutlet var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Card Settings"
    }

    @IBAction func switchLockCard(_ sender: UISwitch) {
        let message: String
        if sender.isOn {
            message = "Your card has been locked successfully"
        } else {
            message = "Your card has been unlocked successfully."
        }
        AMToaster.toast(message, type: .success)
    }
    
    @IBAction func switchOnline(_ sender: UISwitch) {
        statusLabel.text = sender.isOn ? "Activated" : "Deactivated"
        statusLabel.textColor = sender.isOn ? UIColor.c2BB784 : UIColor.c7D7D80
    }
    
}
