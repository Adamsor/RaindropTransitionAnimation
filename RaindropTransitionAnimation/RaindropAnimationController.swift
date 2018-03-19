//
//  RaindropAnimationController.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 28.02.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import UIKit

public class RaindropAnimationController: NSObject {
    let duration: TimeInterval
    let points: [CGPoint]
    let calculationType: RaindropRadiusCalculationType
    
    /// - parameter duration: Animation duration in seconds.
    /// - parameter points: Points from which raindrops will start drawing, can be inside or outside draw context.
    /// - parameter calculationType: Method for calculating raindrops radius (required to properly animate transition).
    public init(duration: TimeInterval, points: [CGPoint], calculationType: RaindropRadiusCalculationType = .simplified(20.0)) {
        self.duration = duration
        self.points = points
        self.calculationType = calculationType
    }
}

extension RaindropAnimationController: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.view(forKey: .from),
            let target = transitionContext.view(forKey: .to),
            let targetController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        let frame = transitionContext.finalFrame(for: targetController)
        
        target.frame = frame
        transitionContext.containerView.insertSubview(target, aboveSubview: source)
        
        let animator = RaindropAnimator(layer: target.layer, properties: RaindropAnimationProperties(points: points, context: frame, radiusCalculation: calculationType))
        animator.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animator.duration = transitionDuration(using: transitionContext)
        animator.completion = {
            source.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        animator.start()
    }
}
