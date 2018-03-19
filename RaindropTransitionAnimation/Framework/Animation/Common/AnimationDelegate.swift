//
//  AnimationDelegate.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 18.03.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import QuartzCore

class AnimationDelegate: NSObject {
    
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
}

extension AnimationDelegate: CAAnimationDelegate {
    
    public func animationDidStop(_: CAAnimation, finished _: Bool) {
        completion()
    }
}
