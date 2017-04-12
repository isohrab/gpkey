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
            let keyFrame = bounds.insetBy(dx: 0, dy: 0)
            let cornerRadius = gpButton.radius
            let keyPath = UIBezierPath(roundedRect: keyFrame, cornerRadius: cornerRadius)
            
            // Fill - with a subtle shadow
            let shadowColor = UIColor.gray
            ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 5.0, color: UIColor(red: 0.66, green: 0.66, blue: 0.66, alpha: 0.8).cgColor)
            ctx.setFillColor(gpButton.bgColor.cgColor)
            ctx.addPath(keyPath.cgPath)
            ctx.fillPath()
            
            // Outline
            ctx.setStrokeColor(shadowColor.cgColor)
            ctx.setLineWidth(0.0)
            ctx.addPath(keyPath.cgPath)
            ctx.strokePath()
            
            if let layer = popUpLayer {
                layer.isHidden = true
            }
            
            if highlighted {
                
                if let layer = popUpLayer {
                    layer.isHidden = false
                }
                else
                {
                    let inset:CGFloat = 10
                    
                    let popupPath = UIBezierPath()
                    let centerBottom = CGPoint(x: bounds.midX, y: bounds.minY)
                    
                    let rightBottom = CGPoint(x: bounds.maxX * 1.1, y: bounds.minY - cornerRadius)
                    let rightBottom1 = CGPoint(x: bounds.maxX * 1.1 - inset, y: bounds.minY - cornerRadius)
                    let rightBottom2 = CGPoint(x: bounds.maxX * 1.1, y: bounds.minY - cornerRadius - inset)
                    
                    let rightTop = CGPoint(x: bounds.maxX * 1.1, y: bounds.minY - bounds.height * 0.8)
                    let rightTop1 = CGPoint(x: bounds.maxX * 1.1, y: bounds.minY - bounds.height * 0.8 + inset)
                    let rightTop2 = CGPoint(x: bounds.maxX * 1.1 - inset, y: bounds.minY - bounds.height * 0.8)
                    
                    let leftTop = CGPoint(x: bounds.minX - (bounds.width * 0.1), y: bounds.minY - bounds.height * 0.8)
                    let leftTop1 = CGPoint(x: bounds.minX - (bounds.width * 0.1) + inset, y: bounds.minY - bounds.height * 0.8)
                    let leftTop2 = CGPoint(x: bounds.minX - (bounds.width * 0.1), y: bounds.minY - bounds.height * 0.8 + inset)
                    
                    let leftBottom = CGPoint(x: bounds.minX - (bounds.width * 0.1), y: bounds.minY - cornerRadius)
                    let leftBottom1 = CGPoint(x: bounds.minX - (bounds.width * 0.1), y: bounds.minY - cornerRadius - inset)
                    let leftBottom2 = CGPoint(x: bounds.minX - (bounds.width * 0.1) + inset, y: bounds.minY - cornerRadius)
                    
                    popupPath.move(to: centerBottom)
                    popupPath.addLine(to: rightBottom1)
                    popupPath.addCurve(to: rightBottom2, controlPoint1: rightBottom, controlPoint2: rightBottom)
                    
                    popupPath.addLine(to: rightTop1)
                    popupPath.addCurve(to: rightTop2, controlPoint1: rightTop, controlPoint2: rightTop)
                    
                    popupPath.addLine(to: leftTop1)
                    popupPath.addCurve(to: leftTop2, controlPoint1: leftTop, controlPoint2: leftTop)
                    
                    popupPath.addLine(to: leftBottom1)
                    popupPath.addCurve(to: leftBottom2, controlPoint1: leftBottom, controlPoint2: leftBottom)
                    popupPath.close()
                    popUpLayer = CAShapeLayer()
                    popUpLayer!.path = popupPath.cgPath
                    popUpLayer!.fillColor = UIColor.green.cgColor
                    popUpLayer!.strokeColor = UIColor.red.cgColor
                    self.addSublayer(popUpLayer!)
                }
                
                ctx.setFillColor(gpButton.bgHighlighted.cgColor)
                ctx.addPath(keyPath.cgPath)
                ctx.fillPath()
            }
        }
    }
}
