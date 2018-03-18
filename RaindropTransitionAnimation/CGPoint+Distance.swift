//
//  CGPoint+Distance.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 28.02.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    /// Euclidean distance from one point to another.
    internal func distance(to point: CGPoint) -> CGFloat {
        return ((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y)).squareRoot()
    }
}
