//
//  UIPanGestureRecognizer.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import UIKit

/// UIPanGestureRecognizer Directions
public enum PanDirection: Int {
    case up, down, left, right, even
    public var isVertical: Bool { [.up, .down].contains(self) }
    public var isHorizontal: Bool { !isVertical }
}

public extension UIPanGestureRecognizer {
    var direction: PanDirection {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return .even
        }
    }
}
