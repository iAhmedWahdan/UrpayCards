//
//  AWToaster.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 08/10/2024.
//

import UIKit

class AWToaster: UIView {
    enum ToastType {
        case success, error, warning, custom(UIImage), none
        
        var image: UIImage? {
            switch self {
            case .success: return UIImage(named: "toastSuccess", in: .urpayCardsAssets, compatibleWith: nil)
            case .error: return UIImage(named: "toastError", in: .urpayCardsAssets, compatibleWith: nil)
            case .warning: return UIImage(named: "toastWarning", in: .urpayCardsAssets, compatibleWith: nil)
            case .custom(let image): return image
            default: return nil
            }
        }
        
        var color: UIColor? {
            switch self {
            case .success: return UIColor(named: "successColor", in: .urpayCardsAssets, compatibleWith: nil)!
            case .error: return UIColor(named: "errorColor", in: .urpayCardsAssets, compatibleWith: nil)!
            case .warning: return UIColor(named: "warningColor", in: .urpayCardsAssets, compatibleWith: nil)!
            default: return nil
            }
        }
    }
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    /// This array holds all the current toasts
    private static var allToasts = [AWToaster]()
    
    private init() { super.init(frame: .zero) }
    private override init(frame: CGRect) { super.init(frame: frame) }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewAppearance()
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewAppearance() {
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.25
        layer.shadowOffset = .zero
    }
    
    public static func toast(_ error: LocalizedError, type: ToastType = .error) {
        toast(error.errorDescription ?? error.localizedDescription, type: type)
    }
    
    public static func toast(_ error: Error, type: ToastType = .error) {
        toast(error.localizedDescription, type: type)
    }
    
    @MainActor
    public static func toast(_ text: String, type: ToastType = .none) {
        switch type {
        case .success: UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning: UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error: UINotificationFeedbackGenerator().notificationOccurred(.error)
        default: UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        
        DispatchQueue.main.async {
            guard let view = Bundle(for: AWToaster.self).loadNibNamed("AWToaster", owner: nil, options: nil)?.first as? AWToaster else {
                // fatalError("Can't load the AMWToaster nib")
                return
            }
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            
            view.show(
                with: text.trimmingCharacters(in: .whitespacesAndNewlines),
                type: type,
                on: window
            )
        }
    }
    
    
    private func show(with text: String, type: ToastType, on window: UIWindow) {
        guard !text.isEmpty else { return }
        
        containerView.backgroundColor = type.color
        textLabel.text = text
        imageView.image = type.image
        imageView.isHidden = type.image == nil
        
        window.addSubview(self)
        
        var topConstraints = [NSLayoutConstraint]()
        
        if Self.allToasts.isEmpty {
            topConstraints += [topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor)]
        } else if let last = Self.allToasts.last {
            topConstraints += [topAnchor.constraint(equalTo: last.bottomAnchor)]
        }
        
        Self.allToasts.append(self)
        
        NSLayoutConstraint.activate(
            topConstraints + [
                centerXAnchor.constraint(equalTo: window.centerXAnchor),
                leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 10),
                trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -10)
                //Full width
                //                leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 10),
                //                trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -10)
            ]
        )
        
        // Force the layout to be calculated before animation starts
        window.layoutIfNeeded()
        
        // Start animation after layout
        transform = transform.translatedBy(x: 0, y: -frame.maxY)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self else { return }
            self.transform = .identity
        }) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.hide()
            }
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.transform = self.transform.translatedBy(x: 0, y: -self.frame.maxY)
        }) { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
            if !Self.allToasts.isEmpty {
                Self.allToasts.removeFirst()
            }
            UIView.animate(withDuration: 0.25) {
                if let first = Self.allToasts.first, let window = first.window {
                    first.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor).isActive = true
                    window.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction func didCloseTap(_ sender: Any) {
        DispatchQueue.main.async {
            self.hide()
        }
    }
}
