//
//  CardSettingsVC.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 09/10/2024.
//

import UIKit

class CardSettingsVC: BaseViewController {
        
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var cancelView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Card Settings"
    }
    
    override func setupUI() {
        super.setupUI()
        applyTheme()
    }
    
    // MARK: - UI Configuration
    
    private func applyTheme() {
        // Apply the current theme to UI elements
        let theme = ThemeManager.shared.config
        ThemeManager.shared.applyTheme(to: self)
        // Apply theme to other UI elements as needed
        cancelView.backgroundColor = theme.backgroundColor2 ?? .c292929
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
