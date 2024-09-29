//
//  ViewController.swift
//  UrpayCards
//
//  Created by iAhmedWahdan on 09/29/2024.
//  Copyright (c) 2024 iAhmedWahdan. All rights reserved.
//

import UIKit
import UrpayCards

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapPayButton(_ sender: Any) {
        UrpayCards.startSession()
    }
    
}

