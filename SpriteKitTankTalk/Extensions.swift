//
//  Extensions.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import UIKit

struct Dispatch {
    static func after(time: NSTimeInterval, block: ()->()) {
        let nanoTime = Int64(time * Double(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoTime)
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            block()
        })
    }
}

extension CGSize {
    var center : CGPoint {
        return CGPoint(x: (self.width / 2.0), y: (self.height / 2.0))
    }
}

extension CGPoint {
    func radiantsToPoint(point: CGPoint) -> CGFloat {
        let xD = Float(self.x - point.x)
        let yD = Float(point.y - self.y)
        let radiants = CGFloat(atan2f(xD, yD))
        return radiants
    }
    
    func distanceToPoint(point: CGPoint) -> CGFloat {
        let xD = self.x - point.x
        let yD = point.y - self.y
        return sqrt(pow(xD, 2.0) + pow(yD, 2.0))
    }
}

func radiansToDegrees(angleRadians: CGFloat) -> CGFloat {
    return CGFloat(Double(angleRadians) * 180.0 / M_PI)
}

