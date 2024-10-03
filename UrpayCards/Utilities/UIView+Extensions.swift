//
//  UIView+Extensions.swift
//  UrpayNewBrand
//
//  Created by Ahmed Wahdan on 04/03/2024.
//

import UIKit

public extension UIView {
    /// loads a full view from a xib file
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIView>() -> T {
            Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        }
        return instantiateFromNib()
    }
}

import AudioToolbox
public extension UIView {
    func shake() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        #if swift(>=4.2)
        animation.valueFunction = CAValueFunction(name: .translateX)
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        #else
        animation.valueFunction = CAValueFunction(name: kCAValueFunctionTranslateX)
        animation.timingFunction = CAMediaTimingFunction(name: "linear")
        #endif
        animation.duration = 0.8
        animation.values = Bool.random() ? [-20, 20, -20, 20, -10, 10, -5, 5, 0] : [20, -20, 20, -20, 10, -10, 5, -5, 0]
        layer.add(animation, forKey: "shake")
    }
    
    func wiggle() {
        guard layer.animation(forKey: "wiggle") == nil else { return }
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        animation.duration = 0.115
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.values = [
            CATransform3DMakeRotation(0.04, 0.0, 0.0, 1),
            CATransform3DMakeRotation(-0.04, 0, 0, 1)
        ]
        layer.add(animation, forKey: "wiggle")
    }
    
    func stopWiggling() {
        layer.removeAnimation(forKey: "wiggle")
    }
}

public extension UIView {
    func bounce(fromValue: CGFloat = 0.97, toValue: CGFloat = 1.03) {
        guard layer.animation(forKey: "bounce") == nil else { return }
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        #if swift(>=4.2)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        #else
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        #endif
        animation.duration = 1.0
        animation.values = [CATransform3DMakeScale(fromValue, fromValue, fromValue), CATransform3DMakeScale(toValue, toValue, toValue)]
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: "bounce")
    }
}

public extension UIView {
    @IBInspectable var isCircled: Bool {
        get {
            false
        }
        set {
            if newValue {
                cornerRadius = bounds.height / 2
                layer.allowsEdgeAntialiasing = true
                
                if #available(iOS 13.0, *) {
                    layer.cornerCurve = .continuous
                }
                
                DispatchQueue.main.async {
                    self.cornerRadius = self.bounds.height / 2
                }
            }
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            layer.masksToBounds
        }
        set {
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 13.0, *) {
                layer.cornerCurve = .continuous
            }
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.allowsEdgeAntialiasing = true
            if #available(iOS 13.0, *) {
                self.traitCollection.performAsCurrent {
                    self.layer.borderColor = newValue.cgColor
                }
            } else {
                layer.borderColor = newValue.cgColor
            }
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            UIColor(cgColor: layer.shadowColor ?? UIColor.lightGray.cgColor)
        }
        set {
            self.traitCollection.performAsCurrent {
                self.layer.shadowColor = newValue.cgColor
            }
        }
    }

    @IBInspectable var shadowRadius: Float {
        get {
            Float(layer.shadowRadius)
        }
        set {
            layer.shadowRadius = CGFloat(newValue)
        }
    }
}

public extension UIView {
    var isShown: Bool {
        get {
            !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
}
