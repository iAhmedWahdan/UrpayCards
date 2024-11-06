//
//  AppColors.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 02/10/2024.
//

import UIKit

extension UIColor {
    
    static let c292929 = UIColor(named: "292929", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c232526 = UIColor(named: "232526", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c151515 = UIColor(named: "151515", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c7D7D80 = UIColor(named: "7D7D80", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c24282D = UIColor(named: "24282D", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let cAE926A = UIColor(named: "AE926A", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c515151 = UIColor(named: "515151", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c535354 = UIColor(named: "535354", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c77664E = UIColor(named: "77664E", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let cB59064 = UIColor(named: "B59064", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let cF05454 = UIColor(named: "F05454", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    static let c2BB784 = UIColor(named: "2BB784", in: .urpayCardsResources, compatibleWith: nil) ?? .black

    static var navigationBarColor2: UIColor {
        return ThemeConfig.shared.navigationBarColor2 ?? UIColor(named: "292929", in: .urpayCardsResources, compatibleWith: nil) ?? .black
    }
}
