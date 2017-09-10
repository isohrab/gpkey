//
//  ViewController.swift
//  GPkey
//
//  Created by sohrab on 19/09/16.
//  Copyright © 2016 ark. All rights reserved.
//


import UIKit
import AudioToolbox

class ViewController: UIViewController{
    

    var tapSound: SystemSoundID = 1104
    var defaultSize: CGSize!
    
    // objects for smilies layer
    var smile:[String] =  ["\u{1F600}", // 😀
                            "\u{1F601}", // 😁
                            "\u{1F602}", // 😂
                            "\u{1F60F}", // 😏
                            "\u{0263A}", // 😘☺
                            "\u{1F917}", // 🤗
                            "\u{1F60D}", // 😍
                            "\u{1F618}", // 😘
                            "\u{1F61C}", // 😜
                            "\u{1F339}", // 🌹
                            "\u{02764}", // 🌹❤
                            
                            "\u{1f614}", // 😔
                            "\u{1F622}", // 😢
                            "\u{1F62D}", // 😭
                            "\u{1F612}", // 😒
                            "\u{1F620}", // 😠
                            "\u{1F624}", // 😤
                            "\u{1F633}", // 😳
                            "\u{1F631}", // 😱
                            "\u{1F60B}", // 😋
                            "\u{1F38A}", // 🎊
                            "\u{1F494}", // 💔
                            
                            "\u{1F610}", // 😐
                            "\u{1F62C}", // 😬
                            "\u{1F644}", // 🙄
                            "\u{1F60E}", // 😎
                            "\u{1F615}", // 😕
                            "\u{1F925}", // 🤥
                            "\u{1F914}", // 🤔
                            "\u{1F922}", // 🤢
                            "\u{1F44C}", // 👌
                            "\u{1F44D}", // 👍
                            "\u{1F64F}"] // 🙏
    var emojiButtons: [UIButton] = [UIButton]()
    var emojiOnOff:Int = 0 // 0: not set, 1: On (default), 2: Off
    let emojiOnOffLabel: UILabel = UILabel()
    var buyButton: UIButton?
    var emojiText:UITextField = UITextField()
    var restoreButton: UIButton?
    var buyLabel: UILabel?

    let prefs = UserDefaults(suiteName: "group.me.alirezak.gachpazh")
    
    /*****************************************
     *                                       *
     *       App main screen function        *
     *                                       *
     ****************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // define default rect for all views
        defaultSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height) / 6)
        
        
        initSmiliesLayer()

        let tap = UITapGestureRecognizer(target: self, action: #selector(messUpEmojies))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    /****************************************
     *                                       *
     *       Initial Emojies Layer           *
     *                                       *
     ****************************************/
    func initSmiliesLayer() {
        
        // setup emoji buttons and description label
        let buttonWidth:CGFloat = (defaultSize.width - (12 * 4)) / 11
        
        // add instruction label on layer
        let l = UILabel()
        l.text = "To change an emoji, you need to just tap on it and with standard emoji keyboard choose your desired emoji."
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.darkGray
        l.numberOfLines = 0
        l.sizeToFit()
        l.frame = CGRect(x: 10, y: 40, width: defaultSize.width - 20, height: 130)
        self.view.addSubview(l)
        
        
        
        // initial buttons 2x11
        let firstHeader = UILabel()
        firstHeader.text = "Emoji in character Layer"
        firstHeader.textColor = UIColor.darkGray
        firstHeader.font = UIFont.boldSystemFont(ofSize: 14)
        firstHeader.sizeToFit()
        firstHeader.frame = CGRect(x: 10, y: defaultSize.height + buttonWidth , width: 200, height: 30)
        self.view.addSubview(firstHeader)
        // calculate default size width = height
        for i in  0...10
        {
            let b = UIButton()
            let emojiInt = prefs?.integer(forKey: String(i))
            if emojiInt != 0
            {
                b.setTitle(String(Character(UnicodeScalar(emojiInt!)!)), for: .normal)
            }
            else
            {
                b.setTitle(smile[i], for: .normal)
            }
            b.translatesAutoresizingMaskIntoConstraints = true
            b.backgroundColor = UIColor.white
            b.layer.borderColor = UIColor.lightGray.cgColor
            b.layer.borderWidth = 1
            b.layer.shadowColor = UIColor.gray.cgColor
            b.layer.shadowOpacity = 0.8
            b.layer.shadowRadius = 0.5
            b.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            b.layer.shadowPath = UIBezierPath(roundedRect: b.bounds, cornerRadius: 5).cgPath
            b.layer.cornerRadius = 5
            b.tag = i
            b.isExclusiveTouch = true
            b.frame = CGRect(x: 4 + (CGFloat(i) * (buttonWidth + 4)), y:  defaultSize.height + (2 * buttonWidth) , width: buttonWidth, height: buttonWidth)
            b.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchDown)
            self.view.addSubview(b)
            emojiButtons.append(b)
        }
        
        let secondHeader = UILabel()
        secondHeader.text = "Emoji in shift Layer"
        secondHeader.textColor = UIColor.darkGray
        secondHeader.font = UIFont.boldSystemFont(ofSize: 14)
        secondHeader.sizeToFit()
        secondHeader.frame = CGRect(x: 10, y:  defaultSize.height + (3 * buttonWidth) , width: 200, height: 30)
        self.view.addSubview(secondHeader)
        
        for i in  0...10
        {
            let b = UIButton()
            let emojiInt = prefs?.integer(forKey: String(i + 11))
            if emojiInt != 0
            {
                b.setTitle(String(Character(UnicodeScalar(emojiInt!)!)), for: .normal)
            }
            else
            {
                b.setTitle(smile[i + 11], for: .normal)
            }
            b.translatesAutoresizingMaskIntoConstraints = true
            b.backgroundColor = UIColor.white
            b.layer.borderColor = UIColor.lightGray.cgColor
            b.layer.borderWidth = 1
            b.layer.shadowColor = UIColor.gray.cgColor
            b.layer.shadowOpacity = 0.8
            b.layer.shadowRadius = 0.5
            b.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            b.layer.shadowPath = UIBezierPath(roundedRect: b.bounds, cornerRadius: 5).cgPath
            b.layer.cornerRadius = 5
            b.tag = i + 11
            b.isExclusiveTouch = true
            b.frame = CGRect(x: 4 + (CGFloat(i) * (buttonWidth + 4)), y: (4 * buttonWidth) +  defaultSize.height, width: buttonWidth, height: buttonWidth)
            b.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
            self.view.addSubview(b)
            emojiButtons.append(b)
        }
        
        let thirdHeader = UILabel()
        thirdHeader.text = "Emoji in number Layer"
        thirdHeader.textColor = UIColor.darkGray
        thirdHeader.font = UIFont.boldSystemFont(ofSize: 14)
        thirdHeader.sizeToFit()
        thirdHeader.frame = CGRect(x: 10, y:  defaultSize.height + (5 * buttonWidth) , width: 200, height: 30)
        self.view.addSubview(thirdHeader)
        
        for i in  0...10
        {
            let b = UIButton()
            let emojiInt = prefs?.integer(forKey: String(i + 22))
            if emojiInt != 0
            {
                b.setTitle(String(Character(UnicodeScalar(emojiInt!)!)), for: .normal)
            }
            else
            {
                b.setTitle(smile[i + 22], for: .normal)
            }
            b.translatesAutoresizingMaskIntoConstraints = true
            b.backgroundColor = UIColor.white
            b.layer.borderColor = UIColor.lightGray.cgColor
            b.layer.borderWidth = 1
            b.layer.shadowColor = UIColor.gray.cgColor
            b.layer.shadowOpacity = 0.8
            b.layer.shadowRadius = 0.5
            b.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            b.layer.shadowPath = UIBezierPath(roundedRect: b.bounds, cornerRadius: 5).cgPath
            b.layer.cornerRadius = 5
            b.tag = i + 22
            b.isExclusiveTouch = true
            b.frame = CGRect(x: 4 + (CGFloat(i) * (buttonWidth + 4)), y: (6 * buttonWidth) +  defaultSize.height, width: buttonWidth, height: buttonWidth)
            b.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
            self.view.addSubview(b)
            emojiButtons.append(b)
        }
        

        // initial emojiText properties, when user touch on button, it will replace with that button
        emojiText.frame = CGRect(x: -100, y: -100, width: buttonWidth, height: buttonWidth)
        emojiText.layer.borderColor = UIColor(red:0.66, green:0.28, blue:0.28, alpha:1.0).cgColor
        emojiText.layer.borderWidth = 1
        emojiText.layer.cornerRadius = 5
        emojiText.tag = -1
        emojiText.backgroundColor = UIColor.white
        emojiText.textAlignment = .center
        emojiText.isExclusiveTouch = true
        emojiText.addTarget(self, action: #selector(insertEmoji), for: .editingChanged)
        self.view.addSubview(emojiText)
        
    }
    

    func restoreEmojiButton()
    {
        emojiButtons[emojiText.tag].layer.opacity = 1.0
        // clear emojiText input for next action
        
    }
    func insertEmoji()
    {
        // TODO: character input policy should set up

        if emojiText.textInputMode?.primaryLanguage != nil
        {
            let alert = UIAlertController(title: "Keyboard Error", message: "Please use apple's standard emoji keyboard as input", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            emojiText.text = ""
            
        }
        else
        {
            // set inserted emoji into selected emojies
            let emojiInt = convertUnicode2Int(emojiText.text!.characters.first!)
            prefs?.set(emojiInt, forKey: String(emojiText.tag))
            prefs?.synchronize()
            
            // set inserted emoji in Button
            emojiButtons[emojiText.tag].setTitle(emojiText.text, for: .normal)
            emojiButtons[emojiText.tag].layer.opacity = 1.0
            emojiText.text = ""
            emojiText.tag = -1
            emojiText.frame = CGRect(x: -100, y: -100, width: emojiText.frame.width, height: emojiText.frame.width)
            emojiText.resignFirstResponder()
        }
    }
    
    
    //: ### emoji button selected
    func emojiSelected(_ sender: UIButton)
    {
        AudioServicesPlaySystemSound(tapSound)
        // restore previous touched button opacity to 1
        if emojiText.tag != -1 && emojiText.tag != sender.tag{
            emojiButtons[emojiText.tag].layer.opacity = 1.0
        }
        sender.layer.opacity = 0
        emojiText.frame = sender.frame
        emojiText.tag = sender.tag
        emojiText.becomeFirstResponder()
    }
    
    func messUpEmojies()
    {
        if emojiText.tag != -1
        {
            emojiButtons[emojiText.tag].layer.opacity = 1
        }
        emojiText.frame = CGRect(x: -100, y: -100, width: emojiText.frame.width, height: emojiText.frame.width)
        emojiText.resignFirstResponder()
        emojiText.text = ""
        emojiText.tag = -1
    }
    func convertUnicode2Int(_ val: Character) -> Int
    {
        let v = String(val)
        for code in v.unicodeScalars
        {
            return Int(code.value)
        }
        return 0
    }

    /*****************************************
     *                                       *
     *       App default function            *
     *                                       *
     ****************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
