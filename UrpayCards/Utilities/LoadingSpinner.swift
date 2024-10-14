//
//  LoadingSpinner.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 14/10/2024.
//

import UIKit

public class LoadingSpinner: UIView {

    // MARK: - Singleton
    public static let shared = LoadingSpinner()

    // MARK: - Constants
    fileprivate static let standardAnimationDuration = 0.33
    private let outerCircleDefaultColor = UIColor.white.cgColor
    private let innerCircleDefaultColor = UIColor.gray.cgColor
    private let defaultTitleFont = UIFont.systemFont(ofSize: 22, weight: .medium)
    private let defaultTitleColor = UIColor.white
    private let frameSize = CGSize(width: 200.0, height: 200.0)
    
    // MARK: - Variables
    fileprivate var _outerColor: UIColor?
    fileprivate var _innerColor: UIColor?
    private var currentOuterRotation: CGFloat = 0.0
    private var currentInnerRotation: CGFloat = 0.1
    private var dismissing: Bool = false
    private var tapHandler: (() -> Void)?
    
    private var currentTitleFont: UIFont
    private var currentTitleColor: UIColor
    
    // MARK: - UI Elements
    private var blurEffectStyle: UIBlurEffect.Style = .dark
    private var blurEffect: UIBlurEffect!
    private var blurView: UIVisualEffectView!
    private var vibrancyView: UIVisualEffectView!
    private lazy var outerCircleView = UIView()
    private lazy var innerCircleView = UIView()
    private let outerCircle = CAShapeLayer()
    private let innerCircle = CAShapeLayer()

    // MARK: - Public properties
    public var titleLabel = UILabel()
    public var subtitleLabel: UILabel?

    public var outerColor: UIColor? {
        get { return _outerColor }
        set {
            _outerColor = newValue ?? .white
            outerCircle.strokeColor = _outerColor?.cgColor ?? UIColor.white.cgColor
        }
    }

    public var innerColor: UIColor? {
        get { return _innerColor }
        set {
            _innerColor = newValue ?? UIColor(named: "cB59064") ?? UIColor.gray
            innerCircle.strokeColor = _innerColor?.cgColor ?? UIColor.gray.cgColor
        }
    }

    
    public var animating: Bool = false {
        willSet {
            if newValue && !animating {
                startAnimations()
            }
        }
        didSet {
            updateCircleStroke()
        }
    }

    public var title: String = "" {
        didSet {
            updateTitleLabel(with: title)
        }
    }
    
    // MARK: - Initialization
    public override init(frame: CGRect = CGRect.zero) {
        self.currentTitleFont = defaultTitleFont
        self.currentTitleColor = defaultTitleColor
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        setupBlurEffect()
        setupTitleLabel()
        setupOuterCircle()
        setupInnerCircle()
    }
    
    private func setupBlurEffect() {
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurView = UIVisualEffectView(effect: blurEffect)
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))

        addSubview(blurView)
        blurView.contentView.addSubview(vibrancyView)
    }

    private func setupTitleLabel() {
        titleLabel.frame.size = CGSize(width: frameSize.width * 0.85, height: frameSize.height * 0.85)
        titleLabel.font = currentTitleFont
        titleLabel.textColor = currentTitleColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byWordWrapping
        
        vibrancyView.contentView.addSubview(titleLabel)
    }

    private func setupOuterCircle() {
        outerCircleView.frame.size = frameSize
        outerCircle.path = UIBezierPath(ovalIn: outerCircleView.bounds).cgPath
        outerCircle.lineWidth = 8.0
        outerCircle.strokeColor = outerCircleDefaultColor
        outerCircle.fillColor = UIColor.clear.cgColor
        outerCircle.strokeStart = 0.0
        outerCircle.strokeEnd = 1.0
        outerCircle.lineCap = .round
        
        outerCircleView.layer.addSublayer(outerCircle)
        vibrancyView.contentView.addSubview(outerCircleView)
    }

    private func setupInnerCircle() {
        innerCircleView.frame.size = frameSize
        let padding: CGFloat = 12
        let insetFrame = innerCircleView.bounds.insetBy(dx: padding, dy: padding)
        innerCircle.path = UIBezierPath(ovalIn: insetFrame).cgPath
        innerCircle.lineWidth = 4.0
        innerCircle.strokeColor = innerCircleDefaultColor
        innerCircle.fillColor = UIColor.clear.cgColor
        innerCircle.strokeStart = 0.0
        innerCircle.strokeEnd = 1.0
        innerCircle.lineCap = .round
        
        innerCircleView.layer.addSublayer(innerCircle)
        vibrancyView.contentView.addSubview(innerCircleView)
    }

    // MARK: - Update Methods
    private func updateTitleLabel(with title: String) {
        guard animating else {
            titleLabel.text = title
            return
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            self.titleLabel.alpha = 0.2
        }) { _ in
            self.titleLabel.text = title
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.0, options: [], animations: {
                self.titleLabel.transform = .identity
                self.titleLabel.alpha = 1.0
            }, completion: nil)
        }
    }

    private func updateCircleStroke() {
        let startValue: CGFloat = animating ? 0.0 : 1.0
        let endValue: CGFloat = animating ? 0.45 : 1.0
        
        outerCircle.strokeStart = startValue
        outerCircle.strokeEnd = endValue
        
        innerCircle.strokeStart = animating ? 0.5 : 0.0
        innerCircle.strokeEnd = animating ? 0.9 : 1.0
    }

    private func startAnimations() {
        spinInner()
        spinOuter()
    }

    // MARK: - Animations
    private func spinOuter() {
        guard superview != nil else { return }

        let randomRotation = CGFloat(Double.random(in: Double.pi/4...Double.pi/2))
        
        // Keep a consistent duration range for smoother rotation
        let duration = Double.random(in: 1.0...1.2)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.currentOuterRotation -= randomRotation
            self.outerCircleView.transform = CGAffineTransform(rotationAngle: self.currentOuterRotation)
        }) { _ in
            // Reduce the delay for smoother continuous animations
            self.delay(0.1) {
                if self.animating {
                    self.spinOuter()
                }
            }
        }
    }

    private func spinInner() {
        guard superview != nil else { return }
        
        // Consistent duration for smoother inner circle rotation
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.currentInnerRotation += CGFloat(Double.pi / 4)
            self.innerCircleView.transform = CGAffineTransform(rotationAngle: self.currentInnerRotation)
        }) { _ in
            // Minimized delay for smoother continuous inner rotation
            self.delay(0.1) {
                if self.animating {
                    self.spinInner()
                }
            }
        }
    }

    // MARK: - Public Methods
    public class func show(title: String, animated: Bool = true) -> LoadingSpinner {
        let spinner = LoadingSpinner.shared
        spinner.updateFrame()
        
        if spinner.superview == nil {
            guard let containerView = containerView() else {
                fatalError("No container view available. Use `useContainerView` to set one.")
            }
            
            containerView.addSubview(spinner)
            spinner.blurView.contentView.alpha = 0
            
            UIView.animate(withDuration: LoadingSpinner.standardAnimationDuration, animations: {
                spinner.blurView.contentView.alpha = 1
            })
        }

        spinner.title = title
        spinner.animating = animated
        return spinner
    }

    public class func hide() {
        let spinner = LoadingSpinner.shared
        spinner.dismissing = true
        
        UIView.animate(withDuration: LoadingSpinner.standardAnimationDuration, animations: {
            spinner.blurView.contentView.alpha = 0
        }) { _ in
            spinner.removeFromSuperview()
            spinner.dismissing = false
        }
    }

    // MARK: - Frame Updates
    public func updateFrame() {
        guard let containerView = LoadingSpinner.containerView() else { return }
        frame = containerView.bounds
        blurView.frame = bounds
        vibrancyView.frame = blurView.bounds
        titleLabel.center = vibrancyView.center
        outerCircleView.center = vibrancyView.center
        innerCircleView.center = vibrancyView.center
    }

    // MARK: - Utility Methods
    private func delay(_ seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    
    // MARK: - Tap Handler
    public func addTapHandler(_ tap: @escaping () -> Void) {
        clearTapHandler()
        tapHandler = tap
    }
    
    public func clearTapHandler() {
        tapHandler = nil
    }

    // MARK: - Private Methods
    private static func containerView() -> UIView? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    @objc private func orientationChangedAction() {
        updateFrame()
    }
}
