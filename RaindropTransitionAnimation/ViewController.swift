//
//  ViewController.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 26.02.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import UIKit
import RaindropFramework

// This is only example and if you would like to use it in such manner please remember, that you shall free references to previous controllers (eg. via unwind segue).
// Otherwise you will have memory leaks.
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        transitioningDelegate = self
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Just some chosen points for demo purpose.
        // Feel free to experiment with other points and/or calculation type.
        return RaindropAnimationController(duration: 1.5, points: [view.center, .zero, CGPoint(x: 500, y: 400)])
    }
}
