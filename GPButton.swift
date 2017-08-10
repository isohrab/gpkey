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

    /**      Char Variables      **/
    var label:UILabel?
    let fontSize: CGFloat = 20
    let fontSizePopup: CGFloat = 28
    let fontName = "Parastoo"
    let fontNameBold = "Parastoo-bold"
    
    
    let backLayer = BackLayer()
    var radius:CGFloat = 5.0
    var backLayerInsetX: CGFloat = 0
    var backLayerInsetY: CGFloat = 0
    
    // Color variables
    static var buttonColor = UIColor.white
    static var buttonHighlighted = UIColor.white
    static var utilBackgroundColor = UIColor(red:0.7, green:0.70, blue:0.73, alpha:1.0)
    static var charColor = UIColor.black
    static var shadowColor = UIColor(red:0.54, green:0.55, blue:0.56, alpha:1.0)
    static var layoutColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0) // color of keyboard layout
    
    var textInsetX:CGFloat = 1
    var textInsetY:CGFloat = 2
    var type:GPButtonType!

    // cursor vaiables
    var forceActivate = false
    var lastStamp:Double = 0
    var dx:CGFloat = 0
    var dt:Int = 0
    var lastLocation:CGPoint = .zero
    
    // popup scale factors
    var scaleX:CGFloat = 0.1
    var scaleY:CGFloat = 0
    
    
    // Harf variable
    weak var harf: Harf? {
        didSet {
            self.label?.text = harf?.face
            updateLayerFrames()
        }
    }
    
    // delegate to protocol
    public var delegate: GPButtonEventsDelegate?
    
    // TODO Do I need this?
    override var intrinsicContentSize: CGSize
    {
        return CGSize(width: 45, height: 52)
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
        backLayer.backgroundColor = GPButton.layoutColor.cgColor
        layer.addSublayer(backLayer)
        label = UILabel()
        label?.frame = bounds.insetBy(dx: textInsetX, dy: textInsetY)
        label?.text = " "
        // TODO: should change it?
        //label?.adjustsFontSizeToFitWidth = true
        if UIAccessibilityIsBoldTextEnabled()
        {
            self.label?.font = UIFont(name: fontNameBold, size: fontSize)
            
        }
        else
        {
            self.label?.font = UIFont(name: fontName, size: fontSize)
        }
        
        label?.textAlignment = .center
        label?.textColor = GPButton.charColor
        label?.minimumScaleFactor = CGFloat(0.1)
        label?.numberOfLines = 1
        self.addSubview(label!)
        type = .CHAR
        updateLayerFrames()
    }
    convenience init(with type: GPButtonType)
    {
        self.init(frame: CGRect.zero)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLayerFrames()
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        backLayer.frame = bounds.insetBy(dx: 0 , dy: 0)
        label?.frame = bounds.insetBy(dx: textInsetX, dy: textInsetY)
        backLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    
    func Highlighting(state:Bool = false)
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.backLayer.highlighted = state
        backLayer.setNeedsDisplay()
        CATransaction.commit()
        
        if self.type! != .CHAR
        {
            return
        }
        if state
        {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            let popupLabelOrigin = bounds.insetBy(dx: -5, dy: -5)
            self.label?.frame = popupLabelOrigin.offsetBy(dx: 0, dy: -bounds.height + 5) // TODO: 1.2???
            if UIAccessibilityIsBoldTextEnabled()
            {
                self.label?.font = UIFont(name: fontNameBold, size: fontSizePopup)
                
            }
            else
            {
                self.label?.font = UIFont(name: fontName, size: fontSizePopup)
            }
            CATransaction.commit()
        }
        else
        {
            self.label?.frame = bounds.insetBy(dx: textInsetX, dy: textInsetY)
            if UIAccessibilityIsBoldTextEnabled()
            {
                self.label?.font = UIFont(name: fontNameBold, size: fontSize)
                
            }
            else
            {
                self.label?.font = UIFont(name: fontName, size: fontSize)
            }
        }
        
    }
    // touches set
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchDown)
        // highlight the button
        Highlighting(state: true)
        
        if let touch = touches.first {
            if touch.tapCount > 1
            {
                sendActions(for: .touchDownRepeat)
            }
            let location = touch.location(in: self)
            lastStamp = touch.timestamp
            lastLocation = location
        }
        dx = 0
        dt = 0
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.preciseLocation(in: self)
            
            // impliment touch events
            let isInside = self.bounds.contains(location)
            let wasInside = self.bounds.contains(lastLocation)
            
            if isInside && wasInside
            {
                sendActions(for: .touchDragInside)
            }
            else if isInside && !wasInside
            {
                sendActions(for: .touchDragEnter)
            }
            else if !isInside && wasInside
            {
                sendActions(for: .touchDragExit)
            }
            else
            {
                sendActions(for: .touchDragOutside)
            }
            // perform cursor movement
            if touch.force / touch.maximumPossibleForce > 0.5
            {
                calculateCursorMovement(touchLoc: location, touchTimeStamp: touch.timestamp)
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.preciseLocation(in: self)
            if self.bounds.contains(location) {
                sendActions(for: .touchUpInside)
            }
            else
            {
                sendActions(for: .touchUpOutside)
            }
        }
        let _ = Timer.scheduledTimer(timeInterval: 0.065, target: self, selector: #selector(Highlighting(state:)), userInfo: nil, repeats: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.preciseLocation(in: self)
            if self.bounds.contains(location) { // TODO: should self.bounds or backLayer.bounds
                sendActions(for: .touchUpInside)
            }
            else
            {
                sendActions(for: .touchUpOutside)
            }
        }
        
        sendActions(for: .touchCancel)
        let _ = Timer.scheduledTimer(timeInterval: 0.065, target: self, selector: #selector(Highlighting(state:)), userInfo: nil, repeats: false)
    }
    
    private func calculateCursorMovement(touchLoc: CGPoint, touchTimeStamp: Double) {
        if lastStamp + 0.1 < touchTimeStamp
        {
            if abs(touchLoc.x + self.center.x) - self.bounds.width < 50
            {
                delegate?.moveCursor(numberOfMovement: 1 * dt)
                if dt < 10 {
                    dt = dt + 1
                }
            }
            else if touchLoc.x + self.center.x > 330
            {
                delegate?.moveCursor(numberOfMovement: -1 * dt)
                if dt < 10 {
                    dt = dt + 1
                }
            }
            else
            {
                dt = 0
                dx = touchLoc.x - lastLocation.x
                if abs(dx) > 5
                {
                    let numberOfMovement = Int(dx / 5)
                    delegate?.moveCursor(numberOfMovement: numberOfMovement * -1)
                    lastLocation = touchLoc
                }
            }
            lastStamp = touchTimeStamp
        }
    }
    
}
