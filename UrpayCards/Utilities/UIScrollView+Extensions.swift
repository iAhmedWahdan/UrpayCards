//
//  UIScrollView+Extensions.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import UIKit

public extension UIScrollView {
    /// Determines if a scrollView offset.y is at the top
    /// Takes into account the adjustedContentInset.top
    /// Values gets rounded before being checked
    var isAtTop: Bool {
        contentOffset.y.rounded() <= -adjustedContentInset.top.rounded()
    }
    
    /// Determines if a scrollView offset.y is at the bottom
    /// Takes into account the adjustedContentInset.bottom
    /// Values gets rounded before being checked
    var isAtBottom: Bool {
        contentOffset.y.rounded() >= verticalOffsetForBottom.rounded()
    }
    
    fileprivate var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = adjustedContentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
