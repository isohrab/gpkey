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
            gpButton.label?.textColor = GPButton.charColor
            let type = gpButton.type!
            
            // TODO: should this value be accessible?
            let keyFrame = bounds.insetBy(dx: gpButton.backLayerInsetX, dy: gpButton.backLayerInsetY)
            let cornerRadius = gpButton.radius
            let keyPath = UIBezierPath(roundedRect: keyFrame, cornerRadius: cornerRadius)
            
            // Fill - with a subtle shadow
            ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 0.0, color: GPButton.shadowColor.cgColor)
            if type == .SHIFT || type == .DELETE || type == .GLOBE || type == .ENTER || type == .NUMBER
            {
                ctx.setFillColor(GPButton.utilBackgroundColor.cgColor)
                ctx.addPath(keyPath.cgPath)
                
            }
            else if type == .EMOJI
            {
                ctx.setFillColor(UIColor.clear.cgColor)
            }
            else
            {
                ctx.setFillColor(GPButton.buttonColor.cgColor)
                ctx.addPath(keyPath.cgPath)
                
            }
            self.backgroundColor = GPButton.layoutColor.cgColor
            ctx.fillPath()
            
            if let layer = popUpLayer {
                layer.isHidden = true
            }
            
            if highlighted {
                if type == .CHAR
                {
                    if let layer = popUpLayer {
                        layer.isHidden = false
                    }
                    else
                    {
                        
                        var popupFrame = bounds.insetBy(dx: -bounds.width * gpButton.scaleX, dy: 0)
                        popupFrame = popupFrame.offsetBy(dx: 0, dy: -bounds.height + 5)
                        let popupPath = UIBezierPath(roundedRect: popupFrame, cornerRadius: 2*cornerRadius)
                        popUpLayer = CAShapeLayer()
                        
                        popUpLayer!.path = popupPath.cgPath
                        popUpLayer!.strokeColor = GPButton.shadowColor.cgColor
                        popUpLayer!.lineWidth = 0.3
                        popUpLayer!.fillColor = GPButton.buttonColor.cgColor
                        self.addSublayer(popUpLayer!)
                    }
                }
                if type == .SPACE || type == .HALBSPACE
                {
                    ctx.setFillColor(GPButton.utilBackgroundColor.cgColor)
                }
                else
                {
                    ctx.setFillColor(GPButton.buttonHighlighted.cgColor)
                }
                ctx.addPath(keyPath.cgPath)
                ctx.fillPath()
            }
        }
    }
}
