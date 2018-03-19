//
//  RaindropAnimator.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 18.03.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import QuartzCore

class RaindropAnimator {
    
    var completion: (() -> Void)?
    fileprivate let layer: CALayer
    fileprivate let mask: CAShapeLayer
    fileprivate let animation: CABasicAnimation
    
    var duration: TimeInterval {
        get { return animation.duration }
        set(value) { animation.duration = value }
    }
    
    var timingFunction: CAMediaTimingFunction! {
        get { return animation.timingFunction }
        set(value) { animation.timingFunction = value }
    }
    
    init(layer: CALayer, properties: RaindropAnimationProperties) {
        let startPath = CGMutablePath()
        let endPath = CGMutablePath()
        
        for point in properties.points {
            startPath.addEllipse(in: CGRect(origin: point, size: CGSize.zero))
            endPath.addEllipse(in: CGRect(origin: point, size: CGSize.zero).insetBy(dx: -properties.radius, dy: -properties.radius))
        }
        
        self.layer = layer
        mask = CAShapeLayer()
        mask.path = endPath
        animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = AnimationDelegate {
            layer.mask = nil
            self.completion?()
            self.animation.delegate = nil
        }
    }
    
    func start() {
        layer.mask = mask
        mask.frame = layer.bounds
        mask.add(animation, forKey: "raindrop")
    }
}
