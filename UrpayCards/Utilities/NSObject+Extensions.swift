//
//  NSObject+Extensions.swift
//  UrpayNewBrand
//
//  Created by Ahmed Wahdan on 04/03/2024.
//

import Foundation

public extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }
    
    class var className: String {
        String(describing: self)
    }
}
