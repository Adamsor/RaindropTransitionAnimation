//
//  ViewController.swift
//  RaindropTransitionAnimation
//
//  Created by Adam Soroczynski on 26.02.2018.
//  Copyright © 2018 Adam Soroczynski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        transitioningDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:  UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RaindropAnimationController(duration: 0.5, points: [view.center])
    }
}
