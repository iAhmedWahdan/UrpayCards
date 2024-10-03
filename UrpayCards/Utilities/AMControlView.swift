//
//  AMControlView.swift
//  UrpayNewBrand
//
//  Created by Ahmed Wahdan on 04/03/2024.
//

import UIKit

class AMControlView: UIControl {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 1/3) {self.transform = CGAffineTransform.init(scaleX: 0.93, y: 0.93)}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {self.transform = .identity}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {self.transform = .identity}
        guard let touch = touches.first else { return }
        if point(inside: touch.location(in: self), with: event) {
            sendActions(for: .touchUpInside)
        }
    }
}
