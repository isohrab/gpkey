//
//  GPButton.swift
//  GPkey
//
//  Created by Alireza Keshavarzi on 3/24/17.
//  Copyright © 2017 ark. All rights reserved.
//

import UIKit

public protocol GPButtonEventsDelegate {
    func moveCursor(numberOfMovement: Int)
}

public enum GPButtonType: Int {
    
    case CHAR
    case ENTER
    case SHIFT
    case DELETE
    case SPACE
    case HALBSPACE
    case NUMBER
    case EMOJI
    case GLOBE
}

class GPButton: UIControl {

    var label:UILabel?
    let backLayer = BackLayer()
    var radius:CGFloat = 5.0
    
    // Color variables
    var bgColor = UIColor.white
    var bgHighlighted = UIColor.lightText
    var utilBackgroundColor = UIColor(red:0.67, green:0.70, blue:0.73, alpha:1.0)
    var titleTextColor = UIColor.black
    var textInsetX:CGFloat = 1
    var textInsetY:CGFloat = 2
    var type:GPButtonType!

    // cursor vaiables
    var forceActivate = false
    var lastStamp:Double = 0
    var dx:CGFloat = 0
    var dt:Int = 0
    var lastLocationX:CGFloat = 0
    
    // delegate to protocol
    public var delegate: GPButtonEventsDelegate?
    
    // TODO Do I need this?
    override var intrinsicContentSize: CGSize
    {
        return CGSize(width: 60, height: 60)
    }
    
    override var bounds: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        backLayer.gpButton = self
        backLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(backLayer)
        label = UILabel()
        label?.frame = bounds.insetBy(dx: textInsetX, dy: textInsetY)
        label?.text = " "
        label?.adjustsFontSizeToFitWidth = true
        self.label?.font = UIFont(name: "Parastoo", size: 20)
        label?.textAlignment = .center
        label?.textColor = titleTextColor
        label?.minimumScaleFactor = CGFloat(0.1)
        label?.isUserInteractionEnabled = false
        label?.numberOfLines = 1
        self.addSubview(label!)
        label?.center = self.center
        type = .CHAR
        updateLayerFrames()
        
    }
    convenience init(with type: GPButtonType)
    {
        self.init(frame: CGRect.zero)
        self.type = type
        if type != .CHAR && type != .SPACE && type != .HALBSPACE
        {
            bgColor = UIColor(red:0.67, green:0.70, blue:0.73, alpha:1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLayerFrames()
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // TODO: should I change the values?
        backLayer.frame = bounds.insetBy(dx: 0 , dy: 0)
        label?.frame = bounds.insetBy(dx: 1, dy: 1)
        backLayer.setNeedsDisplay()
        
        
        CATransaction.commit()
    }
    
    
    
    // touches set
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchDown)
        self.backLayer.highlighted = true
        self.label?.frame = CGRect(x: bounds.minX - (bounds.width * 0.05), y: bounds.minY - (bounds.height * 0.8), width: bounds.width * 1.1, height: bounds.height * 0.6)
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastStamp = touch.timestamp
            lastLocationX = location.x
        }
        dx = 0
        dt = 0
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            // perform cursor movement
            if touch.force / touch.maximumPossibleForce > 0.5
            {
                calculateCursorMovement(touchXLocation: location.x, touchTimeStamp: touch.timestamp)
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backLayer.highlighted = false
        updateLayerFrames()
        if let touch = touches.first {
            let location = touch.preciseLocation(in: self)
            if backLayer.bounds.contains(location) {
                sendActions(for: .touchUpInside)
            }
            else
            {
                sendActions(for: .touchUpOutside)
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        backLayer.highlighted = false
        updateLayerFrames()
        
        if let touch = touches.first {
            let location = touch.preciseLocation(in: self)
            if backLayer.bounds.contains(location) {
                sendActions(for: .touchUpInside)
            }
            else
            {
                sendActions(for: .touchUpOutside)
            }
        }
        
    }
    
    private func calculateCursorMovement(touchXLocation: CGFloat, touchTimeStamp: Double) {
        if lastStamp + 0.1 < touchTimeStamp
        {
            if abs(touchXLocation + self.center.x) - self.bounds.width < 50
            {
                delegate?.moveCursor(numberOfMovement: 1 * dt)
                if dt < 10 {
                    dt = dt + 1
                }
            }
            else if touchXLocation + self.center.x > 330
            {
                delegate?.moveCursor(numberOfMovement: -1 * dt)
                if dt < 10 {
                    dt = dt + 1
                }
            }
            else
            {
                dt = 0
                dx = touchXLocation - lastLocationX
                if abs(dx) > 5
                {
                    let numberOfMovement = Int(dx / 5)
                    delegate?.moveCursor(numberOfMovement: numberOfMovement * -1)
                    lastLocationX = touchXLocation
                }
            }
            lastStamp = touchTimeStamp
        }
    }
}
