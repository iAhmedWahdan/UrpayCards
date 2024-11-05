//
//  CardInformationVC.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 08/10/2024.
//

import UIKit

class CardInformationVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Card Information"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarColor(UIColor.c292929)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        applyTheme()
    }
    
    // MARK: - UI Configuration
    
    private func applyTheme() {
        ThemeManager.shared.applyTheme(to: self)
    }
    
    
    @IBAction func copyNumberTapped(_ sender: Any) {
        UIPasteboard.general.string = "4242424242424242"
        AWToaster.toast("Copied to clipboard", type: .success)
    }
}
