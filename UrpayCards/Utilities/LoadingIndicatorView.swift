//
//  LoadingIndicatorView.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 14/10/2024.
//

import UIKit

class LoadingIndicatorView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let backgroundView = UIView()
    private let messageLabel = UILabel()
    
    // Optional customization properties
    var indicatorColor: UIColor = .white {
        didSet {
            activityIndicator.color = indicatorColor
        }
    }
    
    var message: String? {
        didSet {
            messageLabel.text = message
            messageLabel.isHidden = message == nil
        }
    }
    
    var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            backgroundView.backgroundColor = overlayColor
        }
    }
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // Setup subviews and constraints
    private func setupViews() {
        // Background view
        backgroundView.backgroundColor = overlayColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        // Activity indicator
        activityIndicator.color = indicatorColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        // Message label
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Background view constraints
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Activity indicator constraints
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Message label constraints
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    // Start animating the activity indicator
    func startAnimating() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    // Stop animating the activity indicator
    func stopAnimating() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
