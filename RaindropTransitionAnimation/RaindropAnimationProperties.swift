//
//  RaindropAnimationProperties.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 26.02.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import Foundation
import CoreGraphics

/// To properly animate transition it's required to know raindrops' radius.
/// Otherwise you may find yourself animating transition (denying interaction) without visible effect after some point.
public enum RaindropRadiusCalculationType {
    
    /// Exact value will be calculated (slow for large number of points).
    /// You probably will want to do it once and/or not on main queue.
    case exact
    /// Simplified version will be calculated (every `x` points where `x` is passed value).
    /// `x` must be equal or greater than 1 (for 1 value this works the same way as the `exact` case).
    case simplified(CGFloat)
    /// Custom way to calculate your value (can even be constant).
    /// Can be usefull when eg. animation time is small.
    case custom((_ points: [CGPoint], _ context: CGRect) -> CGFloat)
}

public struct RaindropAnimationProperties {
    
    public var duration: TimeInterval
    public let points: [CGPoint]
    public let context: CGRect
    public let radius: CGFloat
    
    public init(duration: TimeInterval, points: [CGPoint], context: CGRect, radiusCalculation: RaindropRadiusCalculationType) {
        self.duration = duration
        self.points = points
        self.context = context
        
        radius = RaindropAnimationProperties.calculateRadius(points: points, context: context, radiusCalculation: radiusCalculation)
    }
    
    /// This method is used during initialization to calculate radius of the animation.
    static func calculateRadius(points: [CGPoint], context: CGRect, radiusCalculation: RaindropRadiusCalculationType) -> CGFloat {
        let simplificationJump: CGFloat
        
        switch radiusCalculation {
        case .custom(let calculation):
            return calculation(points, context)
        case .exact:
            simplificationJump = 1
        case .simplified(let jump) where jump >= 1:
            simplificationJump = jump
        default:
            return 0
        }
        
        guard !points.isEmpty else {
            // There is no point of calculating radius for no animation points.
            return 0
        }
        
        var maxRadius: CGFloat = 0
        
        // We are looking for radius in following manner:
        // 1. We take point from the context (ideally this is continous).
        // 2. We are looking for the animation point that is closest to our chosen point from context.
        // 3. We get smallest radius for this given point by calculating distance to the closest point.
        // 4. We repeat that for all points in given context.
        // 5. We get largest radius among all smallest radiuses.
        // I found out that this algoritm gives accurate result (mathematicly) but is not optimal at any manner (it depends on the context size and number of animation points).
        // If you find any better way feel free to use own calculation and pass radiusCalculation as .custom case.
        for x in stride(from: context.minX, to: context.maxX + simplificationJump, by: simplificationJump) {
            for y in stride(from: context.minY, to: context.maxY + simplificationJump, by: simplificationJump) {
                // We won't worry about that because our points array is not empty.
                var minRadius: CGFloat = .infinity
                let checkPoint = CGPoint(x: x, y: y)
                
                for point in points {
                    minRadius = min(minRadius, point.distance(to: checkPoint))
                }
                
                maxRadius = max(maxRadius, minRadius)
            }
        }
        
        // Because our calculation is not continous we add calculation error to the maximum radius to be sure it covers whole screen (hopefully won't affect duration much).
        // If we would look at our context it would be divided into the checkboard by the simplificationJump.
        // Thus error is less than half of square's diameter (or equal to).
        let calculationError = simplificationJump * (2.0 as CGFloat).squareRoot() / 2
        
        return maxRadius + calculationError
    }
}
