//
//  SpinnyMcSpinface.swift
//  CALayerTest
//
//  Created by liuzhimin on 17/08/2016.
//  Copyright © 2016 liuzhimin. All rights reserved.
//

import UIKit
import Foundation

extension LZMLayer {
    func startAnimating() {
        var offsetTime = 0.0
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -500.0
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 0, 1)
        
        CATransaction.begin()
        sublayers?.forEach({
            let basic = getSpin(forTransform: transform)
            basic.beginTime = $0.convertTime(CACurrentMediaTime(), to: nil) + offsetTime
            $0.add(basic, forKey: nil)
            offsetTime += 0.1
        })
        CATransaction.commit()
    }
    
    func stopAnimating() {
        sublayers?.forEach({ $0.removeAllAnimations() })
    }
    
    private func getSpin(forTransform transform: CATransform3D) -> CABasicAnimation {
        let basic = CABasicAnimation(keyPath: "transform")
        basic.toValue = NSValue(caTransform3D: transform)
        basic.duration = 1.0
        basic.fillMode = kCAFillModeForwards
        basic.repeatCount = HUGE
        basic.autoreverses = true
        basic.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        basic.isRemovedOnCompletion = false
        return basic
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
