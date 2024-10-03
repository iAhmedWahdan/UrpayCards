//
//  IntrinsicTableView.swift
//  UrpayNewBrand
//
//  Created by Ahmed Wahdan on 07/03/2024.
//

import UIKit

class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        #if swift(>=4.2)
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        #else
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
        #endif
    }
}
