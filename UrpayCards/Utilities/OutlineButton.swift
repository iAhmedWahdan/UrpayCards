//
//  OutlineButton.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 21/10/2024.
//

import UIKit

class OutlineButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // Method to set initial styles
    private func setupButton() {
        self.setTitleColor(UIColor.cAE926A, for: .normal)
        self.layer.borderColor = UIColor.cAE926A.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 1/3) {self.transform = CGAffineTransform.init(scaleX: 0.93, y: 0.93)}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {self.transform = .identity}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {self.transform = .identity}
    }
}
