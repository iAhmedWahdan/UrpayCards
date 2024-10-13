//
//  QRUIManager.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 10/10/2024.
//

import UIKit

class QRUIManager {
    private var qrCodeFrameView: UIView?
    private var qrCodeLabel: UILabel?
    
    func setupQRCodeFrame(in view: UIView) -> UIView {
        let frameView = UIView()
        frameView.layer.borderColor = UIColor.green.cgColor
        frameView.layer.borderWidth = 2
        view.addSubview(frameView)
        view.bringSubviewToFront(frameView)
        qrCodeFrameView = frameView
        return frameView
    }
    
    func setupQRCodeLabel(in view: UIView) -> UILabel {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 50)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Scanning for QR Code..."
        view.addSubview(label)
        view.bringSubviewToFront(label)
        qrCodeLabel = label
        return label
    }
    
    func setupCancelButton(in view: UIView, target: Any, action: Selector) {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        cancelButton.layer.cornerRadius = 5
        cancelButton.frame = CGRect(x: 20, y: 40, width: 80, height: 40)
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
        view.addSubview(cancelButton)
        view.bringSubviewToFront(cancelButton)
    }
    
    func updateQRCodeLabel(withText text: String) {
        qrCodeLabel?.text = text
    }
    
    func updateQRCodeFrame(with frame: CGRect) {
        qrCodeFrameView?.frame = frame
    }
    
    func resetQRCodeFrame() {
        qrCodeFrameView?.frame = CGRect.zero
        updateQRCodeLabel(withText: "Scanning for QR Code...")
    }
}
