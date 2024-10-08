//
//  SlideUpPresentationController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 06/10/2024.
//

import UIKit

class SlideUpPresentationController: UIPresentationController {
    public var dismissVelocityLimit = CGFloat(500)
    public var handleViewSize = CGSize(width: 50, height: 5)
    public var handleViewColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1)
    public var cornerRadius: CGFloat = 15
    
    private var isKeyboardVisible = false
    private var keyboardHeight = CGFloat()
    
    public var allowsDismissing = true
    
    public var scrollView: UIScrollView?
    private var scrollViewContentSizeObserver: NSKeyValueObservation?
    
    /// The background dimming view
    public lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0.0
        view.backgroundColor = .init(white: 0.0, alpha: 1 / 3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rubbingView: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var handleView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.backgroundColor = handleViewColor.cgColor
        view.layer.cornerRadius = handleViewSize.height / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var shouldPresentInFullscreen: Bool {
        true
    }
    
    override func presentationTransitionWillBegin() {
        setupDimmingView()
        setupHandleView()
        setupPresentedView()
        registerKeyboardObservers()
        presentedViewController.preferredContentSize = presentingViewController.view.frame.size
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        rubbingView.removeFromSuperview()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        var frame = containerView.frame
        
        if isKeyboardVisible { frame.size.height -= max(0, keyboardHeight) }
        
        var height: CGFloat
        if let scrollView = scrollView {
            let contentSize = scrollView.contentSize.height + containerView.safeAreaInsets.bottom
            height = min(frame.height * 0.9, contentSize)
        } else {
            height = min(frame.height * 0.9, presentedViewController.preferredContentSize.height)
        }
        
        if let nav = presentedViewController as? UINavigationController {
            height += nav.navigationBar.bounds.height + 100
        }
        
        frame.origin.y = frame.size.height - height
        frame.size.height = height
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard presentedView?.transform.isIdentity ?? false else { return }
        if presentedViewController.isBeingPresented || presentedViewController.isBeingDismissed {
            presentedView?.frame = frameOfPresentedViewInContainerView
        } else {
            UIView.animate(withDuration: 1 / 3, delay: 0, options: [.layoutSubviews], animations: {
                self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            })
        }
    }
    
    private func setupPresentedView() {
        presentedView?.layer.cornerRadius = cornerRadius
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.presentedView?.layer.cornerCurve = .continuous
        
        if let scrollView = presentedView?.subviews.first as? UIScrollView {
            self.scrollView = scrollView
            startScrollViewContentSizeObserver()
        } else if
            let nav = presentedViewController as? UINavigationController,
            let scrollView = nav.topViewController?.view.subviews.first as? UIScrollView
        {
            self.scrollView = scrollView
            startScrollViewContentSizeObserver()
        }
        
        if let view = containerView { addPanGestureTo(view: view) }
        if let view = presentedView { addPanGestureTo(view: view) }
    }
    
    private func startScrollViewContentSizeObserver() {
        scrollView?.contentInsetAdjustmentBehavior = .always
        //        scrollView?.layoutIfNeeded()
        scrollViewContentSizeObserver = scrollView?.observe(\.contentSize, options: .new) { [weak self] _, _ in
            self?.containerView?.setNeedsLayout()
        }
    }
    
    private func addPanGestureTo(view: UIView) {
        view.addGestureRecognizer({
            let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panning))
            pan.delegate = self
            return pan
        }())
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer _: UIContentContainer) {
        containerView?.setNeedsLayout()
    }
    
    override func systemLayoutFittingSizeDidChange(forChildContentContainer _: UIContentContainer) {
        containerView?.setNeedsLayout()
    }
}

// MARK: - DimmingView Setup

extension SlideUpPresentationController {
    private func setupDimmingView() {
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView!.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor)
        ])
        
        addDismissTapGesture()
        
        containerView?.addSubview(rubbingView)
        rubbingView.backgroundColor = presentedViewController.view.backgroundColor
    }
    
    private func addDismissTapGesture() {
        dimmingView.addGestureRecognizer({
            UITapGestureRecognizer(target: self, action: #selector(self.dismissPresentedVC))
        }())
    }
    
    @objc private func dismissPresentedVC() {
        guard allowsDismissing else { return }
        presentedViewController.dismiss(animated: true)
    }
}

// MARK: - HandleView Setup

extension SlideUpPresentationController {
    private func setupHandleView() {
        guard let presentedView = self.presentedView else {
            return
        }
        
        presentedView.addSubview(handleView)
        
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: presentedView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: handleViewSize.width),
            handleView.heightAnchor.constraint(equalToConstant: handleViewSize.height)
        ])
        
        rubbingView.frame = {
            var frame = self.containerView?.frame ?? .zero
            frame.origin.y = frame.maxY - 1
            return frame
        }()
    }
}

// MARK: - Panning Gesture Recognizer

private extension SlideUpPresentationController {
    @objc func panning(_ pan: UIPanGestureRecognizer) {
        guard let containerView = self.containerView, let presentedView = self.presentedView else {
            return
        }
        
        let velocity = pan.velocity(in: containerView)
        let translation = pan.translation(in: containerView)
        
        switch pan.state {
        case .began, .changed:
            
            let newTranslation = CGAffineTransform(translationX: 0, y: {
                if self.allowsDismissing {
                    return translation.y > 0 ? translation.y : translation.y / 15
                } else {
                    return translation.y / 15
                }
            }())
            
            presentedView.transform = newTranslation
            rubbingView.transform = newTranslation
            
            let progress = 1 - (translation.y / presentedView.frame.height)
            dimmingView.alpha = max(0.0, min(1.0, progress))
            
        case .ended, .cancelled, .failed:
            guard allowsDismissing else {
                snapPresentedViewToOriginalFrame()
                return
            }
            
            let reachedDismissTranslation = translation.y > presentedView.frame.height / 2
            let reachedDismissVelocity = velocity.y > dismissVelocityLimit
            
            if reachedDismissTranslation || reachedDismissVelocity {
                presentedViewController.dismiss(animated: true) {
                    self.presentedView?.transform = .identity
                    self.rubbingView.transform = .identity
                }
            } else {
                snapPresentedViewToOriginalFrame()
            }
            
        default: break
        }
    }
    
    private func snapPresentedViewToOriginalFrame() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 0.5,
            options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.presentedView?.transform = .identity
                self.rubbingView.transform = .identity
                self.dimmingView.alpha = 1.0
            }, completion: { _ in
            }
        )
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SlideUpPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer, let scrollView = scrollView else {
            return true
        }
        
        guard scrollView.isTracking else {
            // That means that touches was outside the scrollView
            // So we need to return true to begin this pan gesture
            return true
        }
        
        if scrollView.isAtTop && pan.direction == .down || scrollView.isAtBottom && pan.direction == .up {
            return true
        }
        
        if pan.direction == .left || pan.direction == .right {
            return false
        }
        
        return false
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        scrollView?.panGestureRecognizer == otherGestureRecognizer
    }
}

private extension SlideUpPresentationController {
    // MARK: - Keyboard Handling
    
    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func adjustForKeyboard(notification: Notification) {
        // Define the keys based on the Swift version
        let durationKey: String
        let curveKey: String
        let keyboardFrameKey: String

        #if swift(>=4.2)
        durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        keyboardFrameKey = UIResponder.keyboardFrameEndUserInfoKey
        #else
        durationKey = UIKeyboardAnimationDurationUserInfoKey
        curveKey = UIKeyboardAnimationCurveUserInfoKey
        keyboardFrameKey = UIKeyboardFrameEndUserInfoKey
        #endif

        guard
            let info = notification.userInfo,
            let duration = info[durationKey] as? Double,
            let curveValue = info[curveKey] as? UInt,
            let keyboardFrameValue = info[keyboardFrameKey] as? NSValue,
            let containerView = containerView
        else { return }

        // Update isKeyboardVisible based on the notification
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            isKeyboardVisible = true
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            isKeyboardVisible = false
        }

        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardFrameInContainer = containerView.convert(keyboardFrame, from: nil)
        keyboardHeight = max(0, containerView.bounds.maxY - keyboardFrameInContainer.minY)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curveValue << 16),
            animations: { [weak self] in
                self?.presentedView?.frame = self?.frameOfPresentedViewInContainerView ?? .zero
                self?.containerView?.layoutIfNeeded()
            }
        )
    }

}

// MARK: - SlideUpPresentationViewController

class SlideUpPresentationViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
}

extension SlideUpPresentationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
