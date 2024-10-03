//
//  IntrinsicScrollView.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import UIKit

class IntrinsicScrollView: UIScrollView {

    // Override contentSize to trigger intrinsic content size update when the content size changes
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // Calculate the intrinsic content size based on the content size of the scroll view
    override var intrinsicContentSize: CGSize {
        #if swift(>=4.2)
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        #else
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
        #endif
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the intrinsic content size is recalculated when the layout changes
        invalidateIntrinsicContentSize()
    }
}
