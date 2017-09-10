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
    var iconLayer:CAShapeLayer? = nil
    
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
            
            if type == .DELETE
            {
                let cx = self.frame.midX - 2.5
                let cy = self.frame.midY
                
                let iconPath = UIBezierPath()
                
                // draw x
                let x1 = CGPoint(x: cx - 3.5, y: cy - 3.5)
                let x2 = CGPoint(x: cx + 3.5, y: cy - 3.5)
                let x3 = CGPoint(x: cx + 3.5, y: cy + 3.5)
                let x4 = CGPoint(x: cx - 3.5, y: cy + 3.5)
                
                iconPath.move(to: x1)
                iconPath.addLine(to: x3)
                iconPath.move(to: x2)
                iconPath.addLine(to: x4)
                
                // add border around x
                let p1 = CGPoint(x: cx + 14, y: cy)
                
                let p2 = CGPoint(x: cx + 8, y: cy + 8)
                
                let p31 = CGPoint(x: cx - 5, y: cy + 8)
                let p32 = CGPoint(x: cx - 8, y: cy + 5)
                let p3c1 = CGPoint(x: cx - 6.5, y: cy + 8)
                let p3c2 = CGPoint(x: cx - 8, y: cy + 6.5)
                
                let p41 = CGPoint(x: cx - 8, y: cy - 5)
                let p42 = CGPoint(x: cx - 5, y: cy - 8)
                let p4c1 = CGPoint(x: cx - 8, y: cy - 6.5)
                let p4c2 = CGPoint(x: cx - 6.5, y: cy - 8)

                
                let p5 = CGPoint(x: cx + 8, y: cy - 8)
                
                
                iconPath.move(to: p1)
                iconPath.addLine(to: p2)
                iconPath.addLine(to: p31)
                iconPath.addCurve(to: p32, controlPoint1: p3c1, controlPoint2: p3c2)
                
                iconPath.addLine(to: p41)
                iconPath.addCurve(to: p42, controlPoint1: p4c1, controlPoint2: p4c2)
                
                iconPath.addLine(to: p5)
                
                iconPath.close()
                iconLayer = CAShapeLayer()
                
                iconLayer!.path = iconPath.cgPath
                iconLayer!.lineWidth = 1.5
                iconLayer!.fillColor = UIColor.clear.cgColor
                iconLayer!.strokeColor = GPButton.charColor.cgColor
                self.sublayers?.removeAll()
                self.addSublayer(iconLayer!)
                
            }
            if type == .ENTER
            {
                let cx = self.frame.midX
                let cy = self.frame.midY
                
                // draw Enter sign
                let x1 = CGPoint(x: cx - 8, y: cy - 8)
                let x21 = CGPoint(x: cx - 8, y: cy - 2)
                let x22 = CGPoint(x: cx - 6, y: cy)
                let x3 = CGPoint(x: cx + 10, y: cy)
                let x4 = CGPoint(x: cx + 3, y: cy - 6)
                let x5 = CGPoint(x: cx + 3, y: cy + 6)
                
                // add control points for x2
                let x2c1 = CGPoint(x: cx - 8, y: cy - 1)
                let x2c2 = CGPoint(x: cx - 7, y: cy)
                
                let iconPath = UIBezierPath()
                iconPath.move(to: x1)
                iconPath.addLine(to: x21)
                iconPath.addCurve(to: x22, controlPoint1: x2c1, controlPoint2: x2c2)
                iconPath.addLine(to: x3)
                
                iconPath.move(to: x4)
                iconPath.addLine(to: x3)
                iconPath.addLine(to: x5)
                iconLayer = CAShapeLayer()
                
                iconLayer!.path = iconPath.cgPath
                iconLayer!.lineWidth = 1.5
                iconLayer!.fillColor = UIColor.clear.cgColor
                iconLayer!.strokeColor = GPButton.charColor.cgColor
                self.sublayers?.removeAll()
                self.addSublayer(iconLayer!)
                
            }
            
            if type == .GLOBE
            {
                let cx = self.frame.midX
                let cy = self.frame.midY
                let r = CGFloat(9.5)
                let iconPath = UIBezierPath(arcCenter: CGPoint(x: cx,y: cy), radius: r, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                
                // cross of the globe
                let x1 = CGPoint(x: cx, y: cy - r)
                let x2 = CGPoint(x: cx + r, y: cy)
                let x3 = CGPoint(x: cx, y: cy + r)
                let x4 = CGPoint(x: cx - r, y: cy)
                
                let p45 = r / 2 * sqrt(2)
                
                let c1 = CGPoint(x: cx + p45, y: cy - p45)
                let c2 = CGPoint(x: cx + p45, y: cy + p45)
                let c3 = CGPoint(x: cx - p45, y: cy + p45)
                let c4 = CGPoint(x: cx - p45, y: cy - p45)
                
                iconPath.move(to: x1)
                iconPath.addLine(to: x3)
                iconPath.move(to: x2)
                iconPath.addLine(to: x4)
                
                iconPath.move(to: x1)
                iconPath.addQuadCurve(to: x3, controlPoint: x2)
                iconPath.addQuadCurve(to: x1, controlPoint: x4)
                
                iconPath.move(to: c1)
                iconPath.addQuadCurve(to: c4, controlPoint: CGPoint(x: cx, y: cy))
                iconPath.move(to: c2)
                iconPath.addQuadCurve(to: c3, controlPoint: CGPoint(x: cx, y: cy))
                
                iconLayer = CAShapeLayer()
                
                iconLayer!.path = iconPath.cgPath
                iconLayer!.lineWidth = 1
                iconLayer!.fillColor = UIColor.clear.cgColor
                iconLayer!.strokeColor = GPButton.charColor.cgColor
                self.sublayers?.removeAll()
                self.addSublayer(iconLayer!)
                
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
                        popUpLayer!.lineWidth = 0.3
                        popUpLayer!.fillColor = GPButton.buttonColor.cgColor
                        popUpLayer!.strokeColor = GPButton.shadowColor.cgColor
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
