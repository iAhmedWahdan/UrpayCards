//
//  IntrinsicContainerView.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import UIKit

class IntrinsicContainerView: UIView {
    
    // Override the intrinsic content size property to calculate height dynamically
    override var intrinsicContentSize: CGSize {
        let contentHeight = self.subviews
            .map { $0.frame.maxY }
            .max() ?? 0
        
        #if swift(>=4.2)
        return CGSize(width: UIView.noIntrinsicMetric, height: contentHeight)
        #else
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentHeight)
        #endif
    }
    
    // Override layoutSubviews to invalidate the intrinsic content size when layout changes
    override func layoutSubviews() {
        super.layoutSubviews()
        // Invalidate intrinsic content size to recalculate it whenever the layout updates
        invalidateIntrinsicContentSize()
    }
}
