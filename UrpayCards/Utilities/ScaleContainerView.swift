//
//  ScaleContainerView.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 22/10/2024.
//

import UIKit

class ScaleContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        let theme = ThemeManager.shared.config
        backgroundColor = theme.backgroundColor2 ?? .c292929
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
