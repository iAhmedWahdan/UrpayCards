//
//  SlideUpPresentationController.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 06/10/2024.
//

import UIKit

class SlideUpPresentationController: UIPresentationController {
    
    // MARK: - Customizable Properties
    
    public var allowsDismissing: Bool = true
    public var cornerRadius: CGFloat = 15.0
    public var dimmingViewColor: UIColor = UIColor(white: 0.0, alpha: 1 / 3)
    public var handleViewSize: CGSize = CGSize(width: 50, height: 5)
    public var animationDuration: TimeInterval = 0.3
    public var animationOptions: UIView.AnimationOptions = [.curveEaseInOut]
    public var dimmingViewTapHandler: (() -> Void)?
    
    private struct Constants {
        static let dismissVelocityLimit = CGFloat(500)
    }
    
    // MARK: - Private Properties
    
    private var isKeyboardVisible = false
    private var keyboardHeight: CGFloat = 0.0
    
    private var scrollView: UIScrollView?
    private var scrollViewContentSizeObserver: NSKeyValueObservation?
    
    /// The background dimming view
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0.0
        view.backgroundColor = dimmingViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rubbingView: UIView = {
        let view = UIView()
        view.backgroundColor = presentedViewController.view.backgroundColor
        return view
    }()
    
    private lazy var handleView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.918, alpha: 1.0) // #E5E5EA
        view.layer.cornerRadius = handleViewSize.height / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        registerKeyboardObservers()
        registerOrientationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        scrollViewContentSizeObserver?.invalidate()
        scrollViewContentSizeObserver = nil
    }
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        setupDimmingView(in: containerView)
        setupHandleView()
        setupPresentedView()
        setupGestureRecognizers()
        
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
        var frame = containerView.bounds
        
        if isKeyboardVisible {
            frame.size.height -= keyboardHeight
        }
        
        let preferredHeight: CGFloat
        
        if let scrollView = scrollView {
            let contentHeight = scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom + containerView.safeAreaInsets.bottom
            preferredHeight = min(frame.height * 0.9, contentHeight)
        } else {
            preferredHeight = min(frame.height * 0.9, presentedViewController.preferredContentSize.height)
        }
        
        frame.origin.y = frame.height - preferredHeight
        frame.size.height = preferredHeight
        
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let containerView = containerView else { return }
        presentedView?.frame = frameOfPresentedViewInContainerView
        rubbingView.frame = containerView.bounds
    }
    
    // MARK: - Setup Methods
    
    private func setupDimmingView(in containerView: UIView) {
        dimmingView.backgroundColor = dimmingViewColor
        containerView.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        addDismissTapGesture()
        containerView.addSubview(rubbingView)
    }
    
    private func addDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dimmingViewTapped() {
        dimmingViewTapHandler?()
        if allowsDismissing {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupHandleView() {
        guard let presentedView = presentedView else { return }
        presentedView.addSubview(handleView)
        
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: presentedView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: handleViewSize.width),
            handleView.heightAnchor.constraint(equalToConstant: handleViewSize.height)
        ])
        
        rubbingView.frame = containerView?.bounds ?? .zero
    }
    
    private func setupPresentedView() {
        guard let presentedView = presentedView else { return }
        presentedView.layer.cornerRadius = cornerRadius
        presentedView.layer.masksToBounds = true
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if #available(iOS 13.0, *) {
            presentedView.layer.cornerCurve = .continuous
        }
        
        if let scrollView = findScrollView(in: presentedViewController.view) {
            self.scrollView = scrollView
            startScrollViewContentSizeObserver()
        }
    }
    
    private func setupGestureRecognizers() {
        if let containerView = containerView {
            addPanGestureTo(view: containerView)
        }
        if let presentedView = presentedView {
            addPanGestureTo(view: presentedView)
        }
    }
    
    private func addPanGestureTo(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panning(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Scroll View Handling
    
    private func startScrollViewContentSizeObserver() {
        scrollView?.contentInsetAdjustmentBehavior = .always
        scrollViewContentSizeObserver = scrollView?.observe(\.contentSize, options: .new, changeHandler: { [weak self] _, _ in
            self?.containerView?.setNeedsLayout()
        })
    }
    
    private func findScrollView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for subview in view.subviews {
            if let found = findScrollView(in: subview) {
                return found
            }
        }
        return nil
    }
    
    // MARK: - Gesture Handling
    
    @objc private func panning(_ panGesture: UIPanGestureRecognizer) {
        guard let presentedView = presentedView, let containerView = containerView else { return }
        
        let translation = panGesture.translation(in: containerView)
        let velocity = panGesture.velocity(in: containerView)
        
        switch panGesture.state {
        case .began, .changed:
            var yOffset = translation.y
            if !allowsDismissing && yOffset > 0 {
                yOffset /= 15
            }
            let transform = CGAffineTransform(translationX: 0, y: yOffset)
            presentedView.transform = transform
            rubbingView.transform = transform
            let progress = max(0.0, min(1.0, 1 - (translation.y / presentedView.frame.height)))
            dimmingView.alpha = progress
            
        case .ended, .cancelled, .failed:
            guard allowsDismissing else {
                snapPresentedViewToOriginalPosition()
                return
            }
            let shouldDismiss = translation.y > presentedView.frame.height / 2 || velocity.y > Constants.dismissVelocityLimit
            if shouldDismiss {
                presentedViewController.dismiss(animated: true) {
                    self.presentedView?.transform = .identity
                    self.rubbingView.transform = .identity
                }
            } else {
                snapPresentedViewToOriginalPosition()
            }
            
        default:
            break
        }
    }
    
    private func snapPresentedViewToOriginalPosition() {
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [weak self] in
            self?.presentedView?.transform = .identity
            self?.rubbingView.transform = .identity
            self?.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: - Keyboard Handling
    
    private func registerKeyboardObservers() {
#if swift(>=4.2)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
#else
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: .UIKeyboardWillChangeFrame,
                                               object: nil)
#endif
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
#if swift(>=4.2)
        guard
            let info = notification.userInfo,
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let containerView = containerView
        else { return }
#else
        guard
            let info = notification.userInfo,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = info[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let keyboardFrameValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let containerView = containerView
        else { return }
#endif
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardFrameInContainer = containerView.convert(keyboardFrame, from: nil)
        keyboardHeight = max(0, containerView.bounds.maxY - keyboardFrameInContainer.minY)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curveValue << 16), animations: { [weak self] in
            self?.presentedView?.frame = self?.frameOfPresentedViewInContainerView ?? .zero
            self?.containerView?.layoutIfNeeded()
        })
    }
    
    // MARK: - Orientation Handling
    
    private func registerOrientationObserver() {
#if swift(>=4.2)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
#else
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationChange), name: .UIDeviceOrientationDidChange, object: nil)
#endif
    }
    
    @objc private func handleDeviceOrientationChange() {
        containerView?.setNeedsLayout()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SlideUpPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard
            let panGesture = gestureRecognizer as? UIPanGestureRecognizer,
            let scrollView = scrollView
        else { return true }
        
        let velocity = panGesture.velocity(in: gestureRecognizer.view)
        let isVerticalPan = abs(velocity.y) > abs(velocity.x)
        
        if !isVerticalPan {
            return false
        }
        
        let isScrollingUp = velocity.y < 0
        
        if isScrollingUp {
            return scrollView.contentOffset.y <= 0
        } else {
            if scrollView.contentOffset.y <= 0 {
                return true
            }
            return false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollViewPanGesture = scrollView?.panGestureRecognizer {
            return otherGestureRecognizer == scrollViewPanGesture
        }
        return false
    }
}

// MARK: - Accessibility

extension SlideUpPresentationController {
    override func accessibilityPerformEscape() -> Bool {
        if allowsDismissing {
            presentedViewController.dismiss(animated: true)
            return true
        }
        return false
    }
}

// MARK: - SlideUpPresentationViewController

class SlideUpPresentationViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
}

extension SlideUpPresentationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
