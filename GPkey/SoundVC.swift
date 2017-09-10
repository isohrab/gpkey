//
//  SoundVC.swift
//  GPkey
//
//  Created by sohrab on 01/11/2016.
//  Copyright © 2016 ark. All rights reserved.
//

import UIKit
import AudioToolbox

class SoundVC: UIViewController {

    var tapSound: SystemSoundID = 1104
    let topSound: SystemSoundID = 1105
    let vibSound: SystemSoundID = 1520
    
    var soundButtons:[UIButton] = [UIButton]()
    
    var defaultSize: CGSize!
    
    let prefs = UserDefaults(suiteName: "group.me.alirezak.gpkeys")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        initSoundLayer()
    }

    func initSoundLayer() {
        // inital objects in sound layer
        let buttonPadding = (defaultSize.width - 300) / 4
        for i in 0...2
        {
            let b: UIButton = UIButton()
            b.layer.borderWidth = 2
            b.layer.cornerRadius = 15
            b.tag = i+1
            b.layer.borderColor = UIColor(colorLiteralRed: 50, green: 150, blue: 250, alpha: 1.0).cgColor
            b.frame = CGRect(x: buttonPadding + (CGFloat(i) * (100 + buttonPadding)) , y: 100, width: 100, height: 100)
            b.addTarget(self, action: #selector(soundChange(_:_:)), for: .touchUpInside)
            soundButtons.append(b)
            self.view.addSubview(b)
        }
        soundButtons[0].setImage(UIImage(named:"mute"), for: UIControlState.normal)
        soundButtons[1].setImage(UIImage(named:"vibration"), for: UIControlState.normal)
        soundButtons[2].setImage(UIImage(named:"soundOn"), for: UIControlState.normal)
        
        // read user data for sound
        let button:UIButton = UIButton()
        if let sound = prefs?.integer(forKey: "sound")
        {
            if sound != 0 {
                button.tag = sound
            }
            button.tag = 3
        }
        soundChange(button, true)
    }
    
    // here we set the sound setting
    func soundChange(_ sender: UIButton, _ playSound: Bool = false) {
        // add selected button to setting boundle
        prefs?.set(sender.tag, forKey: "sound")
        prefs?.synchronize()
        // set all buttons to default style
        for b in soundButtons
        {
            b.layer.borderWidth = 2
            b.layer.borderColor = UIColor.darkGray.cgColor
        }
        switch sender.tag {
        case 1:
            // user tapped button mute
            self.soundButtons[0].layer.borderColor = UIColor.green.cgColor
            self.soundButtons[0].layer.borderWidth = 4
            break
        case 2:
            // user tapped button vibration
            self.soundButtons[1].layer.borderColor = UIColor.green.cgColor
            self.soundButtons[1].layer.borderWidth = 4
            if !playSound {
                AudioServicesPlaySystemSound(vibSound)
            }
            
            break
        case 3:
            // user tapped button Sound ON
            self.soundButtons[2].layer.borderColor = UIColor.green.cgColor
            self.soundButtons[2].layer.borderWidth = 4
            if !playSound {
                AudioServicesPlaySystemSound(tapSound)
            }
            break
        default:
            print("nothing")
            break
        }
        
    }
    

}
