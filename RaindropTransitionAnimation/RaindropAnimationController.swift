//
//  RaindropAnimationController.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 28.02.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import UIKit

public class RaindropAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval
    let points: [CGPoint]
    let calculationType: RaindropRadiusCalculationType
    
    public init(duration: TimeInterval, points: [CGPoint], calculationType: RaindropRadiusCalculationType = .simplified(20.0)) {
        self.duration = duration
        self.points = points
        self.calculationType = calculationType
    }
    
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // This method can only be a nop if the transition is interactive and not a percentDriven interactive transition.
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
    
    /// A conforming object implements this method if the transition it creates can
    /// be interrupted. For example, it could return an instance of a
    /// UIViewPropertyAnimator. It is expected that this method will return the same
    /// instance for the life of a transition.
    @available(iOS 10.0, *)
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        preconditionFailure()
    }
}
