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
            
//            // get size of button with respect of inset values
//            let w = gpButton.frame.width
//            let h = gpButton.frame.height
            let type = gpButton.type!
//            switch type {
//            case .DELETE:
//                // inset width and height
//                let p1 = CGPoint(x: w * 0.3, y: h * 0.35)
//                let p2 = CGPoint(x: w * 0.75, y: h * 0.35)
//                let p3 = CGPoint(x: w * 0.75, y: h * 0.65)
//                let p4 = CGPoint(x: w * 0.3, y: h * 0.65)
//                let p5 = CGPoint(x: w * 0.2, y: h * 0.5)
//                
//                let px1 = CGPoint(x: w * 0.35, y: h * 0.25)
//                let px2 = CGPoint(x: w * 0.35, y: h * 0.75)
//                let px3 = CGPoint(x: w * 0.55, y: h * 0.25)
//                let px4 = CGPoint(x: w * 0.55, y: h * 0.75)
//                
//                let delPath = UIBezierPath()
//                delPath.move(to: p1)
//                delPath.addLine(to: p2)
//                delPath.addLine(to: p3)
//                delPath.addLine(to: p4)
//                delPath.addLine(to: p5)
//                delPath.close()
//                
//                delPath.move(to: px1)
//                delPath.addLine(to: px3)
//                
//                delPath.move(to: px2)
//                delPath.addLine(to: px4)
//                
//                let delLayer = CAShapeLayer()
//                delLayer.path = delPath.cgPath
//                delLayer.strokeColor = UIColor.black.cgColor
//                delLayer.lineWidth = 1
//                self.addSublayer(delLayer)
//                //                setNeedsDisplay()
//                break
//            case .GLOBE:
//                
//                let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
//                
//                let shapeLayer = CAShapeLayer()
//                shapeLayer.path = circlePath.cgPath
//                
//                //change the fill color
//                shapeLayer.fillColor = UIColor.clear.cgColor
//                //you can change the stroke color
//                shapeLayer.strokeColor = UIColor.red.cgColor
//                //you can change the line width
//                shapeLayer.lineWidth = 3.0
//                
//                self.addSublayer(shapeLayer)
//                break
//            default:
//                break
//            }
//            
            
            
            // TODO: should this value be accessible?
            let keyFrame = bounds.insetBy(dx: gpButton.backLayerInsetX, dy: gpButton.backLayerInsetY)
            let cornerRadius = gpButton.radius
            let keyPath = UIBezierPath(roundedRect: keyFrame, cornerRadius: cornerRadius)
            
            // Fill - with a subtle shadow
            ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 0.0, color: gpButton.shadowColor.cgColor)
            ctx.setFillColor(gpButton.bgColor.cgColor)
            ctx.addPath(keyPath.cgPath)
            ctx.fillPath()
            displayIfNeeded()
            
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
                        popUpLayer!.strokeColor = gpButton.shadowColor.cgColor
                        popUpLayer!.lineWidth = 0.3
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
