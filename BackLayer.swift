//
//  backLayer.swift
//  ver2keyTest
//
//  Created by Alireza Keshavarzi on 3/14/17.
//  Copyright © 2017 Alireza Keshavarzi. All rights reserved.
//

import UIKit
import QuartzCore

class BackLayer: CALayer {
    
    var highlighted = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            if let _ = popUpLayer {
                popUpLayer = nil
            }
        }
    }
    var popUpLayer:CAShapeLayer? = nil
    
    weak var gpButton: GPButton?
    
    override func draw(in ctx: CGContext) {
        if let gpButton = gpButton {
            
            // TODO: should this value be accessible?
            let keyFrame = bounds.insetBy(dx: 0, dy: 1)
            let cornerRadius = gpButton.radius
            let keyPath = UIBezierPath(roundedRect: keyFrame, cornerRadius: cornerRadius)
            
            // Fill - with a subtle shadow
            ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 0.0, color: gpButton.shadowColor.cgColor)
            ctx.setFillColor(gpButton.bgColor.cgColor)
            ctx.addPath(keyPath.cgPath)
            ctx.fillPath()
            
            if let layer = popUpLayer {
                layer.isHidden = true
            }
            
            if highlighted {
                
                let type = gpButton.type!
                if type == .CHAR
                {
                    if let layer = popUpLayer {
                        layer.isHidden = false
                    }
                    else
                    {
                        
                        var popupFrame = bounds.insetBy(dx: -10, dy: -10)
                        popupFrame = popupFrame.offsetBy(dx: 0, dy: -bounds.height)
                        let popupPath = UIBezierPath(roundedRect: popupFrame, cornerRadius: 2*cornerRadius)
                        popUpLayer = CAShapeLayer()
                        popUpLayer!.path = popupPath.cgPath
                        popUpLayer!.fillColor = gpButton.bgColor.cgColor
                        self.addSublayer(popUpLayer!)
                    }
                }
                ctx.setFillColor(gpButton.bgHighlighted.cgColor)
                ctx.addPath(keyPath.cgPath)
                ctx.fillPath()
            }
        }
    }
}
