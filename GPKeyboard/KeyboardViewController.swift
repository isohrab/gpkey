//
//  KeyboardViewController.swift
//  Gachpazh Keyboard
//
//  Created by sohrab on 09/09/16.
//  Copyright © 2016 ark.sohrab. All rights reserved.
//


// TODO: bug in shift button when 123 button touched

import UIKit
import AudioToolbox

class KeyboardViewController: UIInputViewController, GPButtonEventsDelegate {
    
    // 1396 - 1397 - 1306:char - 1155:delete - 1156:space+number+shift+return
    let delSound: SystemSoundID = 1155
    let charSound: SystemSoundID = 1306
    let utilSound: SystemSoundID = 1156
    let vibSound: SystemSoundID = 1520
    var SoundState: Int = 0
    
    /****************************
     *   define alphabet value   *
     ****************************/
    
    

    // [layer][row][column]
    let characters :[[[Harf]]]=[[[
        // first layer: first row:
        Harf.init(name: "zad",  face: "ض", output: "ض", returnable: false, spaceReturnable: false),
        Harf.init(name: "sad",  face: "ص", output: "ص", returnable: false, spaceReturnable: false),
        Harf.init(name: "ghaf", face: "ق", output: "ق", returnable: false, spaceReturnable: false),
        Harf.init(name: "fe",   face: "ف", output: "ف", returnable: false, spaceReturnable: false),
        Harf.init(name: "ghein",face: "غ", output: "غ", returnable: false, spaceReturnable: false),
        Harf.init(name: "ein",  face: "ع", output: "ع", returnable: false, spaceReturnable: false),
        Harf.init(name: "ha",   face: "ه", output: "ه", returnable: false, spaceReturnable: false),
        Harf.init(name: "khe",  face: "خ", output: "خ", returnable: false, spaceReturnable: false),
        Harf.init(name: "he",   face: "ح", output: "ح", returnable: false, spaceReturnable: false),
        Harf.init(name: "je",   face: "ج", output: "ج", returnable: false, spaceReturnable: false),
        Harf.init(name: "che",  face: "چ", output: "چ", returnable: false, spaceReturnable: false)],
                                  
        //first Layer, Second Row:
        [Harf.init(name: "she", face: "ش", output: "ش", returnable: false, spaceReturnable: false),
         Harf.init(name: "se",  face: "س", output: "س", returnable: false, spaceReturnable: false),
         Harf.init(name: "ye",  face: "ی", output: "ی", returnable: false, spaceReturnable: false),
         Harf.init(name: "be",  face: "ب", output: "ب", returnable: false, spaceReturnable: false),
         Harf.init(name: "lam", face: "ل", output: "ل", returnable: false, spaceReturnable: false),
         Harf.init(name: "alef",face: "ا", output: "ا", returnable: false, spaceReturnable: false),
         Harf.init(name: "te",  face: "ت", output: "ت", returnable: false, spaceReturnable: false),
         Harf.init(name: "non", face: "ن", output: "ن", returnable: false, spaceReturnable: false),
         Harf.init(name: "mim", face: "م", output: "م", returnable: false, spaceReturnable: false),
         Harf.init(name: "ke",  face: "ک", output: "ک", returnable: false, spaceReturnable: false),
         Harf.init(name: "ge",  face: "گ", output: "گ", returnable: false, spaceReturnable: false)],
        
        //first Layer, Third Row:
        [Harf.init(name: "za",  face: "ظ", output: "ظ", returnable: false, spaceReturnable: false),
         Harf.init(name: "ta",  face: "ط", output: "ط", returnable: false, spaceReturnable: false),
         Harf.init(name: "ze",  face: "ز", output: "ز", returnable: false, spaceReturnable: false),
         Harf.init(name: "re",  face: "ر", output: "ر", returnable: false, spaceReturnable: false),
         Harf.init(name: "zal", face: "ذ", output: "ذ", returnable: false, spaceReturnable: false),
         Harf.init(name: "dal", face: "د", output: "د", returnable: false, spaceReturnable: false),
         Harf.init(name: "pe",  face: "پ", output: "پ", returnable: false, spaceReturnable: false),
         Harf.init(name: "ve",  face: "و", output: "و", returnable: false, spaceReturnable: false)],
        
        // first Layer, Fourth Row:
        [Harf.init(name: "se3noghte",face: "ث", output: "ث", returnable: false, spaceReturnable: false),
         Harf.init(name: "zhe",      face: "ژ", output: "ژ", returnable: false, spaceReturnable: false)]],
                                 
        // Shift LAYER
        // Second Layer: first Row:
        [[Harf.init(name: "saken",      face: "ْ",          output: "ْ",        returnable: true, spaceReturnable: false),
          Harf.init(name: "o",          face: "ُ",          output: "ُ",        returnable: true, spaceReturnable: false),
          Harf.init(name: "e",          face: "ِ",          output: "ِ",        returnable: true, spaceReturnable: false),
          Harf.init(name: "a",          face: "َ",          output: "َ",        returnable: true, spaceReturnable: false),
          Harf.init(name: "an",         face: "ً",          output: "ً",        returnable: true, spaceReturnable: false),
          Harf.init(name: "parantezL",  face: "\u{0028}",   output: "\u{0029}", returnable: false, spaceReturnable: true),
          Harf.init(name: "parantezR",  face: "\u{0029}",   output: "\u{0028}", returnable: false, spaceReturnable: true),
          Harf.init(name: "akoladL",    face: "\u{007B}",   output: "\u{007D}", returnable: false, spaceReturnable: true),
          Harf.init(name: "akoladR",    face: "\u{007D}",   output: "\u{007B}", returnable: false, spaceReturnable: true),
          Harf.init(name: "beraketL",   face: "\u{005b}",   output: "\u{005d}", returnable: false, spaceReturnable: true),
          Harf.init(name: "beraketR",   face: "\u{005d}",   output: "\u{005b}", returnable: false, spaceReturnable: true)],
         
         // second Layer, Second Row:
            [Harf.init(name: "bullet",  face: "•",      output: "•",        returnable: false, spaceReturnable: true),
             Harf.init(name: "underline",face: "_",     output: "_",        returnable: false, spaceReturnable: true),
             Harf.init(name: "yeHamze", face: "ئ",      output: "ئ",        returnable: true, spaceReturnable: false),
             Harf.init(name: "tashdid", face: "\u{0651}", output: "\u{0651}", returnable: true, spaceReturnable: false),
             Harf.init(name: "hamze",   face: "ء",      output: "ء",        returnable: true, spaceReturnable: false),
             Harf.init(name: "abakola", face: "آ",      output: "آ",        returnable: true, spaceReturnable: false),
             Harf.init(name: "keshidan",face: "ـ",      output: "ـ",        returnable: false, spaceReturnable: true),
             Harf.init(name: "2fleshL", face: "\u{00ab}", output: "\u{00bb}", returnable: false, spaceReturnable: true),
             Harf.init(name: "2fleshR", face: "\u{00bb}", output: "\u{00ab}", returnable: false, spaceReturnable: true),
             Harf.init(name: "apostroph",face: "'",     output: "'",        returnable: true, spaceReturnable: false),
             Harf.init(name: "quotation",face: "\"",    output: "\"",       returnable: false, spaceReturnable: true)],
            
            //second layer, third Row:
            [Harf.init(name: "noghte",      face: ".",  output: ".",        returnable: false, spaceReturnable: true),
             Harf.init(name: "virgol",      face: "،", output: "،",         returnable: false, spaceReturnable: true),
             Harf.init(name: "3noghte",     face: "\u{2026}", output: "\u{2026}", returnable: false, spaceReturnable: true),
             Harf.init(name: "donoghte",    face: ":",  output: ":",        returnable: false, spaceReturnable: true),
             Harf.init(name: "semicolon",   face: "؛",  output: "؛",        returnable: false, spaceReturnable: true),
             Harf.init(name: "centigrad",   face: "°",  output: "°",        returnable: false, spaceReturnable: true),
             Harf.init(name: "soal",        face: "؟",  output: "؟",        returnable: false, spaceReturnable: true),
             Harf.init(name: "tajob",       face: "!",  output: "!",        returnable: false, spaceReturnable: true)],
            
            // second layer, fourth Row:
            [Harf.init(name: "atsign",      face: "@", output: "@", returnable: false, spaceReturnable: true),
             Harf.init(name: "sharp",       face: "#", output: "#", returnable: false, spaceReturnable: true)]],
        
        //Number layer
        // first Row:
        [[Harf.init(name: "yek",face: "۱", output: "۱", returnable: false, spaceReturnable: false),
          Harf.init(name: "do",face: "۲", output: "۲", returnable: false, spaceReturnable: false),
          Harf.init(name: "se",face: "۳", output: "۳", returnable: false, spaceReturnable: false),
          Harf.init(name: "char",face: "۴", output: "۴", returnable: false, spaceReturnable: false),
          Harf.init(name: "panj",face: "۵", output: "۵", returnable: false, spaceReturnable: false),
          Harf.init(name: "shesh",face: "۶", output: "۶", returnable: false, spaceReturnable: false),
          Harf.init(name: "haft",face: "۷", output: "۷", returnable: false, spaceReturnable: false),
          Harf.init(name: "hasht",face: "۸", output: "۸", returnable: false, spaceReturnable: false),
          Harf.init(name: "noh",face: "۹", output: "۹", returnable: false, spaceReturnable: false),
          Harf.init(name: "sefr",face: "۰", output: "۰", returnable: false, spaceReturnable: false)],
         
         //second Row:
            [Harf.init(name: "mad",face: "~", output: "~", returnable: false, spaceReturnable: false),
             Harf.init(name: "bala",face: "^", output: "^", returnable: false, spaceReturnable: false),
             Harf.init(name: "dollar",face: "$", output: "$", returnable: false, spaceReturnable: false),
             Harf.init(name: "star",face: "*", output: "*", returnable: false, spaceReturnable: false),
             Harf.init(name: "darsad",face: "٪", output: "٪", returnable: false, spaceReturnable: false),
             Harf.init(name: "mosavi",face: "=", output: "=", returnable: false, spaceReturnable: false),
             Harf.init(name: "mosbat",face: "+", output: "+", returnable: false, spaceReturnable: false),
             Harf.init(name: "menha", face: "-",output: "-", returnable: false, spaceReturnable: false),
             Harf.init(name: "zarb",face: "×", output: "×", returnable: false, spaceReturnable: false),
             Harf.init(name: "taghsim",face: "÷", output: "÷", returnable: false, spaceReturnable: false)],
            
            //third Row:
            [Harf.init(name: "prime",face: "`", output: "`", returnable: false, spaceReturnable: false),
             Harf.init(name: "coma-pool",face: "،", output: "،", returnable: false, spaceReturnable: false),
             Harf.init(name: "euro",face: "€", output: "€", returnable: false, spaceReturnable: false),
             Harf.init(name: "register",face: ".", output: ".", returnable: false, spaceReturnable: false),
             Harf.init(name: "Copyright",face: ":", output: ":", returnable: false, spaceReturnable: false),
             Harf.init(name: "small",face: "<", output: ">", returnable: false, spaceReturnable: false),
             Harf.init(name: "great",face: ">", output: "<", returnable: false, spaceReturnable: false),
             Harf.init(name: "pipe",face: "|", output: "|", returnable: false, spaceReturnable: true)],
            
            // fourht row:
            [Harf.init(name: "slash",face: "/", output: "/", returnable: false, spaceReturnable: false),
             Harf.init(name: "backslash",face: "\\", output: "\\", returnable: false, spaceReturnable: false)]]]
    
    // the smiles are changable in main App
    var smile:[String] =  ["\u{1F600}","\u{1F601}","\u{1F602}","\u{1F60E}","\u{1F60D}","\u{1F618}","\u{0263A}","\u{1F61C}",
                           "\u{1F914}","\u{1F339}","\u{02764}","\u{1F610}","\u{1F61E}","\u{1F62D}","\u{1F633}","\u{1F631}",
                           "\u{1F620}","\u{1F621}","\u{1F382}","\u{1F381}","\u{1F38A}","\u{1F494}"]
    /*************************************
     *                                    *
     *   Define Global Value              *
     *   - keyboards layers               *
     *   - keyboard dimension and points  *
     *                                    *
     *************************************/
    
    var gapHorizontal: CGFloat = 6    // in iPad screens should be multiply by 2
    var gapVertical: CGFloat = 10        // in iPad Screen should be multiply by 2
    var alefbaButtonWidth: CGFloat = 0  // should be calculated according to UIScreen
    var allButtonHeight: CGFloat = 0 // should be calculated according to UIScreen
    var numberButtonWidth: CGFloat = 0  // should be calculated according to UIScreen
    var emojiButtonWidth: CGFloat = 0
    var emojiButtonHeight: CGFloat = 0
    var marginTop:CGFloat = 10     // in iPad screen it should be multiply by 2
    var shift: Bool = true         // show state of shift button
    var deleting: Bool = false  // when it is true, continuing deleting characters
    var deleteTimer: TimeInterval = 0.3    // it will accelerate deleting upto 500 milisecond
    var timer:Timer!
    
    // colors
    var buttonBackground = UIColor.white    // color of button in noraml state
    var viewBackground = UIColor(red:0.82, green:0.84, blue:0.86, alpha:1.0)    // main background color
    var utilBackgroundColor = UIColor(red:0.67, green:0.70, blue:0.73, alpha:1.0)   // color of util button in normal state
    var textColorNormal = UIColor.black
    var textColorHighlighted = UIColor.black
    var makeButtonBiggerTextColor = UIColor.black
    var buttonShadowColor = UIColor.gray.cgColor
    var utilButtonTouchDownColor = UIColor.white
    var buttonBorderColor = UIColor.gray.cgColor
    var makeButtonBiggerBackground = UIColor(red:0.90, green:0.89, blue:0.89, alpha:1.0)
    
    /*******    Layout variabels     *********/
    var alefbaLayout: UIView!
    var numberButtons:[[GPButton]]!
    
    var numberLayout: UIView!
    var alefbaButtons:[[GPButton]]!
    
    
    /*******  user pref variables   ********/
    var emojiState = 0
    
    
    
    
    /******************************************
     *                                        *
     *   initial Alefba Layout                *
     *                                        *
     *****************************************/
    
    func initAlefbaLayout(){
        // TODO: background should be checked here
        alefbaLayout.backgroundColor = viewBackground
        
        // setup tap detection for background view
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        alefbaLayout.addGestureRecognizer(tap)
        
        alefbaButtons = [[GPButton]]()
        
        // check user setting if he want to use smily. Also
        if emojiState == 1
        {
            var rowButtons = [GPButton]()
            for i in 0...10
            {
                let btn = GPButton(with: .EMOJI)
                btn.label?.text = smile[i]
                rowButtons.append(btn)
                btn.backLayerInsetX = 0
                btn.backLayerInsetY = 0
                btn.addTarget(self, action: #selector(self.emojiTouched(_:)), for: .touchUpInside)
                alefbaLayout.addSubview(btn)

            }
            alefbaButtons.append(rowButtons)
        }
        
        
        for i in 0..<characters[0].count
        {
            var rowButtons = [GPButton]()
            for j in 0..<characters[0][i].count
            {
                let btn = GPButton(with: .CHAR)
                
                btn.harf = characters[0][i][j]
                rowButtons.append(btn)
                btn.backLayerInsetX = gapHorizontal / 2
                btn.backLayerInsetY = gapVertical / 2
                btn.isExclusiveTouch = true
                btn.addTarget(self, action: #selector(self.charTouched(_:)), for: .touchUpInside)
                alefbaLayout.addSubview(btn)
            }
            alefbaButtons.append(rowButtons)
        }
        // add all util function

        let shiftButton = GPButton(with: .SHIFT)
        shiftButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        shiftButton.label?.text = ".؟!"
        shiftButton.backLayerInsetX = gapHorizontal / 2
        shiftButton.backLayerInsetY = gapVertical / 2
        alefbaButtons[emojiState + 2].insert(shiftButton, at: 0)
        alefbaLayout.addSubview(shiftButton)
        
        let deleteButton = GPButton(with: .DELETE)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown(sender:)), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUp(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUp(_:)), for: .touchUpOutside)
        deleteButton.label?.text = "dele"
        deleteButton.backLayerInsetX = gapHorizontal / 2
        deleteButton.backLayerInsetY = gapVertical / 2
        alefbaButtons[emojiState + 2].insert(deleteButton, at: alefbaButtons[emojiState + 2].count)
        alefbaLayout.addSubview(deleteButton)
        
        let numberButton = GPButton(with: .NUMBER)
        numberButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        numberButton.label?.text = "۱۲۳"
        numberButton.backLayerInsetX = gapHorizontal / 2
        numberButton.backLayerInsetY = gapVertical / 2
        alefbaButtons[emojiState + 3].insert(numberButton, at: 0)
        alefbaLayout.addSubview(numberButton)
        
        let globeButton = GPButton(with: .GLOBE)
        globeButton.backLayerInsetX = gapHorizontal / 2
        globeButton.backLayerInsetY = gapVertical / 2
        globeButton.label?.text = "globe"
        alefbaButtons[emojiState + 3].insert(globeButton, at: 1)
        alefbaLayout.addSubview(globeButton)
        globeButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .touchDown)
        
        let spaceButton = GPButton(with: .SPACE)
        spaceButton.label?.text = "فاصله"
        spaceButton.backLayerInsetX = gapHorizontal / 2
        spaceButton.backLayerInsetY = gapVertical / 2
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        alefbaButtons[emojiState + 3].insert(spaceButton, at: 3)
        alefbaLayout.addSubview(spaceButton)
        
        let enterButton = GPButton(with: .ENTER)
        enterButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        enterButton.label?.text = "enter"
        enterButton.backLayerInsetX = gapHorizontal / 2
        enterButton.backLayerInsetY = gapVertical / 2
        alefbaButtons[emojiState + 3].insert(enterButton, at: 5)
        alefbaLayout.addSubview(enterButton)
        
        // calculate constraints
        setAlefbaConstraints(buttons: alefbaButtons, kbLayout: alefbaLayout, topSpace: marginTop, buttonWidth: alefbaButtonWidth, buttonHeight: allButtonHeight)
        
        // I do it by hand! because it is different with numberlayout
        alefbaLayout.addConstraint(NSLayoutConstraint(item: shiftButton, attribute: .width, relatedBy: .equal, toItem: deleteButton, attribute: .width, multiplier: 1, constant: 0))
    }
    
    /******************************************
     *                                        *
     *   initial Number Layout                *
     *                                        *
     *****************************************/
    
    func initNumberLayout(){
        // TODO: background should be checked here
        numberLayout.backgroundColor = viewBackground
    
        numberButtons = [[GPButton]]()
        
        // check user setting if he want to use smily. Also
        if emojiState == 1
        {
            var rowButtons = [GPButton]()
            for i in 0...10
            {
                let btn = GPButton(with: .EMOJI)
                btn.label?.text = smile[i]
                rowButtons.append(btn)
                btn.backLayerInsetX = 0
                btn.backLayerInsetY = 0
                btn.addTarget(self, action: #selector(self.emojiTouched(_:)), for: .touchUpInside)
                numberLayout.addSubview(btn)
                
            }
            numberButtons.append(rowButtons)
        }
        
        
        
        for i in 0..<characters[2].count
        {
            var rowButtons = [GPButton]()
            for j in 0..<characters[2][i].count
            {
                let btn = GPButton(with: .CHAR)
                
                btn.harf = characters[2][i][j]
                rowButtons.append(btn)
                btn.backLayerInsetX = gapHorizontal / 2
                btn.backLayerInsetY = gapVertical / 2
                btn.isExclusiveTouch = true
                btn.addTarget(self, action: #selector(self.charTouched(_:)), for: .touchUpInside)
                numberLayout.addSubview(btn)
            }
            numberButtons.append(rowButtons)
        }
        // add all util function
        let deleteButton = GPButton(with: .DELETE)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown(sender:)), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUp(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUp(_:)), for: .touchUpOutside)
        deleteButton.label?.text = "dele"
        deleteButton.backLayerInsetX = gapHorizontal / 2
        deleteButton.backLayerInsetY = gapVertical / 2
        numberButtons[emojiState + 2].insert(deleteButton, at: numberButtons[emojiState + 2].count)
        numberLayout.addSubview(deleteButton)
        
        let numberButton = GPButton(with: .NUMBER)
        numberButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        numberButton.label?.text = "الفبا"
        numberButton.backLayerInsetX = gapHorizontal / 2
        numberButton.backLayerInsetY = gapVertical / 2
        numberButtons[emojiState + 3].insert(numberButton, at: 0)
        numberLayout.addSubview(numberButton)
        
        let globeButton = GPButton(with: .GLOBE)
        globeButton.backLayerInsetX = gapHorizontal / 2
        globeButton.backLayerInsetY = gapVertical / 2
        globeButton.label?.text = "globe"
        numberButtons[emojiState + 3].insert(globeButton, at: 1)
        numberLayout.addSubview(globeButton)
        globeButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .touchDown)
        
        let spaceButton = GPButton(with: .SPACE)
        spaceButton.label?.text = "نیم‌فاصله"
        spaceButton.backLayerInsetX = gapHorizontal / 2
        spaceButton.backLayerInsetY = gapVertical / 2
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        numberButtons[emojiState + 3].insert(spaceButton, at: 3)
        numberLayout.addSubview(spaceButton)
        
        let enterButton = GPButton(with: .ENTER)
        enterButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        enterButton.label?.text = "enter"
        enterButton.backLayerInsetX = gapHorizontal / 2
        enterButton.backLayerInsetY = gapVertical / 2
        numberButtons[emojiState + 3].insert(enterButton, at: 5)
        numberLayout.addSubview(enterButton)
        
        // Calculate constraint
        setNumbersConstraints(buttons: numberButtons, kbLayout: numberLayout, topSpace: marginTop, buttonWidth: numberButtonWidth, buttonHeight: allButtonHeight)
        
    }
    /************************************
    *       DELETE FUNCTION             *
    ************************************/
    // delete touching
    func deleteTouchDown(sender: GPButton)
    {
        playSound(for: delSound)
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.deleteBackward()
        deleting = true
        timer = Timer.scheduledTimer(timeInterval: deleteTimer, target: self, selector: #selector(doDeleting), userInfo: nil, repeats: false)
    }
    
    func doDeleting()
    {
        if deleting
        {
            
            let proxy = textDocumentProxy as UITextDocumentProxy
            proxy.deleteBackward()
            if deleteTimer > 0.1
            {
                deleteTimer -= 0.08
            }
            if proxy.documentContextBeforeInput != nil
            {
                timer = Timer.scheduledTimer(timeInterval: deleteTimer, target: self, selector: #selector(doDeleting), userInfo: nil, repeats: false)
                playSound(for: delSound)
            }
            else
            {
                proxy.deleteBackward()
                timer = Timer.scheduledTimer(timeInterval: deleteTimer, target: self, selector: #selector(doDeleting), userInfo: nil, repeats: false)
                
            }
            
        }
    }
    // set deleting boolean value to false with this event
    func deleteTouchUp(_ sender: GPButton)
    {
        deleting = false
        deleteTimer = 0.3
        timer.invalidate()
    }
    
    /************************************
     *       UTIL  FUNCTION             *
     ************************************/
    
    func utilTouched(sender: GPButton)
    {
        
        let proxy = textDocumentProxy as UITextDocumentProxy
        let type = sender.type!
        switch type
        {
        case .SPACE:
            playSound(for: utilSound)
            proxy.insertText(" ")
            break
        case .GLOBE:
            self.advanceToNextInputMode()
            break
        case .SHIFT:
            playSound(for: utilSound)
            doShift(shifting: shift)
            shift = !shift
            break
        case .NUMBER:
            playSound(for: utilSound)
            if alefbaLayout.layer.opacity == 0
            {
                numberLayout.layer.opacity = 0
                alefbaLayout.layer.opacity = 1
            }
            else
            {
                alefbaLayout.layer.opacity = 0
                numberLayout.layer.opacity = 1
            }
            break
        case .ENTER:
            playSound(for: utilSound)
            proxy.insertText("\n")
            break
        case .HALBSPACE:
            playSound(for: utilSound)
            proxy.insertText("\u{200C}")
            break
        default:
            break
        }
    }
    
    /************************************
     *       SHIFT FUNCTION             *
     ************************************/
    func doShift(shifting:Bool)
    {
        if shifting
        {
            if emojiState == 1
            {
                for i in 0...10
                {
                    alefbaButtons[0][i].label?.text = smile[i+11]
                    
                }
            }
            // row 1 and 2
            for i in 0...1
            {
                for j in 0...10
                {
                    alefbaButtons[emojiState + i][j].harf = characters[1][i][j]
                }
            }
            
            // row 3 is include shift and delete button
            for j in 1...8
            {
                alefbaButtons[emojiState + 2][j].harf = characters[1][2][j-1]
            }
            // 4th row, the buttons beside the space
            alefbaButtons[emojiState + 3][2].harf = characters[1][3][0]
            alefbaButtons[emojiState + 3][4].harf = characters[1][3][1]
            // half space
            alefbaButtons[emojiState + 3][3].label?.text = "نیم‌فاصله"
        }
        else
        {
            if emojiState == 1
            {
                for i in 0...10
                {
                    alefbaButtons[0][i].label?.text = smile[i]
                    
                }
            }
            // row 1 and 2
            for i in 0...1
            {
                for j in 0...10
                {
                    alefbaButtons[emojiState + i][j].harf = characters[0][i][j]
                }
            }
            
            // row 3 is include shift and delete button
            for j in 1...8
            {
                alefbaButtons[emojiState + 2][j].harf = characters[0][2][j-1]
            }
            // 4th row, the buttons beside the space
            alefbaButtons[emojiState + 3][2].harf = characters[0][3][0]
            alefbaButtons[emojiState + 3][4].harf = characters[0][3][1]
            // half space
            alefbaButtons[emojiState + 3][3].label?.text = "فاصله"
        }
    }
    
    /************************************
     *       OTHER  FUNCTION            *
     ************************************/
    // add character into textfield
    func charTouched(_ sender: GPButton)
    {
        playSound(for: charSound)
        let proxy = textDocumentProxy as UITextDocumentProxy
        guard let char = sender.harf?.output else {return}
        proxy.insertText(char)
    }
    
    func emojiTouched(_ sender: GPButton)
    {
        playSound(for: charSound)
        let proxy = textDocumentProxy as UITextDocumentProxy
        guard let char = sender.label?.text else {return}
        proxy.insertText(char)
    }


    func playSound(for type:UInt32)
    {
        // mute mode
        if SoundState == 0
        {
            return  // Quiet! >:/
        }
        
        // vibrate mode
        if SoundState == 1
        {
            AudioServicesPlaySystemSound(vibSound)
            return
        }
        
        AudioServicesPlaySystemSound(type)
    }
    
    
    func getCharacterFromNearestButton(_ sender: UITapGestureRecognizer)
    {
        let loc = sender.location(in: sender.view)
        if loc.y < 20 && emojiState == 0
        {
            dismissKeyboard()
        }
        
    }
    
    func setAlefbaConstraints(buttons: [[GPButton]], kbLayout: UIView, topSpace:CGFloat, buttonWidth:CGFloat, buttonHeight: CGFloat)
    {
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: buttons[emojiState][0], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonWidth))
        constraints.append(NSLayoutConstraint(item: buttons[emojiState][0], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonHeight))
        
        for i in 0..<buttons.count
        {
            for j in 0..<buttons[i].count
            {
                
                
                // it is first row, so it should stick to top of the kbLayout
                if i==0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .top, relatedBy: .equal, toItem: kbLayout, attribute: .top, multiplier: 1, constant: topSpace))
                }
                
                // it is first button of i-th row. so it should be stick to left edge
                if j==0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .left, relatedBy: .equal, toItem: kbLayout, attribute: .left, multiplier: 1, constant: 0))
                }
                
                // it is the last row, so it should be sticked to bottom of the kbLayout
                if i == buttons.count-1
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .bottom, relatedBy: .equal, toItem: kbLayout, attribute: .bottom, multiplier: 1, constant: 0 * -1))
                }
                
                // it is the last button of i-th row, it should be stick to the right side of kbLayout
                if j == buttons[i].count-1
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .right, relatedBy: .equal, toItem: kbLayout, attribute: .right, multiplier: 1, constant: 0 * -1))
                }
                
                // set all buttons in i-th row equal to Horizontal gap
                if j > 0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .left, relatedBy: .equal, toItem: buttons[i][j-1], attribute: .right, multiplier: 1, constant: 0))
                }
                
                if i > 0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .top, relatedBy: .equal, toItem: buttons[i-1][j], attribute: .bottom, multiplier: 1, constant: 0))
                }
                
                let type = buttons[i][j].type!
                // all buttons should have same height (except emoji buttons)
                if type != .EMOJI
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .height, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .height, multiplier: 1, constant: 0))
                }
                
                // assign width constraint to buttons according to its characteristic
                switch type
                {
                case .CHAR:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1, constant: 0))
                    break
                case .EMOJI:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: emojiButtonWidth))
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: emojiButtonHeight))
                    break
                case .SHIFT, .DELETE:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1.5, constant: 0))
                    break
                case .ENTER:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1.75, constant: 0))
                    break
                case .SPACE, .HALBSPACE:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: buttons[emojiState][0], attribute: .width, multiplier: 3, constant: 0))
                    break
                case .GLOBE, .NUMBER:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1.25, constant: 0))
                    break
                }
            }
        }
        
        kbLayout.addConstraints(constraints)
    }

    func setNumbersConstraints(buttons: [[GPButton]], kbLayout: UIView, topSpace:CGFloat, buttonWidth:CGFloat, buttonHeight: CGFloat)
    {
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: buttons[emojiState][0], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonWidth))
        constraints.append(NSLayoutConstraint(item: buttons[emojiState][0], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonHeight))
        
        for i in 0..<buttons.count
        {
            for j in 0..<buttons[i].count
            {
                
                
                // it is first row, so it should stick to top of the kbLayout
                if i==0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .top, relatedBy: .equal, toItem: kbLayout, attribute: .top, multiplier: 1, constant: topSpace))
                }
                
                // it is first button of i-th row. so it should be stick to left edge
                if j==0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .left, relatedBy: .equal, toItem: kbLayout, attribute: .left, multiplier: 1, constant: 0))
                }
                
                // it is the last row, so it should be sticked to bottom of the kbLayout
                if i == buttons.count-1
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .bottom, relatedBy: .equal, toItem: kbLayout, attribute: .bottom, multiplier: 1, constant: 0 * -1))
                }
                
                // it is the last button of i-th row, it should be stick to the right side of kbLayout
                if j == buttons[i].count-1
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .right, relatedBy: .equal, toItem: kbLayout, attribute: .right, multiplier: 1, constant: 0 * -1))
                }
                
                // set all buttons in i-th row equal to Horizontal gap
                if j > 0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .left, relatedBy: .equal, toItem: buttons[i][j-1], attribute: .right, multiplier: 1, constant: 0))
                }
                
                if i > 0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .top, relatedBy: .equal, toItem: buttons[i-1][j], attribute: .bottom, multiplier: 1, constant: 0))
                }
                
                let type = buttons[i][j].type!
                // all buttons should have same height (except emoji buttons)
                if type != .EMOJI
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .height, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .height, multiplier: 1, constant: 0))
                }
                
                // assign width constraint to buttons according to its characteristic
                switch type
                {
                case .CHAR:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1, constant: 0))
                    break
                case .EMOJI:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: emojiButtonWidth))
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: emojiButtonHeight))
                    break
                case .SHIFT, .DELETE:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1.5, constant: 0))
                    break
                case .ENTER:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1.75, constant: 0))
                    break
                case .SPACE, .HALBSPACE:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 3, constant: alefbaButtonWidth))
                    break
                case .GLOBE, .NUMBER:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1.25, constant: 0))
                    break
                }
            }
        }
        
        kbLayout.addConstraints(constraints)
    }
    /****************************************
     *                                       *
     *   System default function             *
     *                                       *
     ****************************************/
    override func updateViewConstraints()
    {
        super.updateViewConstraints()
        
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        calculateVariables()
        setAlefbaConstraints(buttons: alefbaButtons, kbLayout: alefbaLayout, topSpace: marginTop, buttonWidth: alefbaButtonWidth, buttonHeight: allButtonHeight)
        setNumbersConstraints(buttons: numberButtons, kbLayout: numberLayout, topSpace: marginTop, buttonWidth: numberButtonWidth, buttonHeight: allButtonHeight)
        
        updateViewConstraints()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("override func viewWillAppear(_ animated: Bool)")
        print(UIScreen.main.bounds.size.width)
        super.viewWillAppear(animated)
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            viewBackground = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
//            utilBackgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
//            buttonBackground = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0)
//            textColorNormal = UIColor.white
//            textColorHighlighted = UIColor.lightGray
//            makeButtonBiggerTextColor = UIColor.white
//            makeButtonBiggerBackground = UIColor.gray
//        }
        
        
        
        /**** initial Alefba layer    ****/
        alefbaLayout = UIView()
        alefbaLayout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(alefbaLayout)
        alefbaLayout.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        alefbaLayout.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        alefbaLayout.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        alefbaLayout.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        initAlefbaLayout()
        alefbaLayout.layer.opacity = 1
        
        
        /**** Initial Number Layer  ****/
        numberLayout = UIView()
        numberLayout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(numberLayout)
        numberLayout.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        numberLayout.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        numberLayout.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        numberLayout.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        initNumberLayout()
        numberLayout.layer.opacity = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        
        
        // TODO: Should I Calculate here? iPad!, Landscape......
        let prefs = UserDefaults(suiteName: "group.me.alirezak.gpkeys")
        if let val = prefs?.integer(forKey: "emojiState") {
            emojiState = val
            
        }
        else
        {
            emojiState = 1  // default = show emojies
        }
        
        // retreive user Sound settings
        SoundState = prefs?.integer(forKey: "sound") ?? 2
        
        
        // get all variable according current device state
        calculateVariables()
        
    }

    func calculateVariables()
    {
        // we should fix allButtonHeight for landscape and Portrait mode
        if UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        {   /*  _____
             * |     |
             * |     |
             * |     |
             * |     |
             * |__o__|
             */
            
            // determine device multiplier
            let wmp = UIScreen.main.bounds.size.width / 375    // width multiplier
            
            alefbaButtonWidth = (UIScreen.main.bounds.size.width / 11) * wmp
            numberButtonWidth = (UIScreen.main.bounds.size.width / 10) * wmp
            allButtonHeight = (alefbaButtonWidth * 1.55) * wmp
            emojiButtonWidth = alefbaButtonWidth
            emojiButtonHeight = alefbaButtonWidth
            
            gapHorizontal = 6 * wmp
            gapVertical = 10 * wmp
            marginTop = 10 * wmp
            
            if emojiState == 0
            {
                marginTop = (allButtonHeight * wmp) - gapVertical
            }
        }
        else
        {
            /*  __________
             * |         |
             * |         o
             * |_________|
             *
             */
            
            // determine device multiplier
            let wmp = UIScreen.main.bounds.size.width / 667    // width multiplier
            
            alefbaButtonWidth = (UIScreen.main.bounds.size.width / 11) * wmp
            numberButtonWidth = (UIScreen.main.bounds.size.width / 10) * wmp
            allButtonHeight = (UIScreen.main.bounds.size.height / 11) * 1.25 * wmp
            emojiButtonWidth = alefbaButtonWidth
            emojiButtonHeight = allButtonHeight
            gapHorizontal = 6 * wmp * 1.5
            gapVertical = 10 * wmp
            marginTop = 10 * wmp
            
            if emojiState == 0
            {
                marginTop = (allButtonHeight * wmp) - gapVertical
            }
        }
    }
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        /*let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            viewBackground = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
            utilBackgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
            buttonBackground = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0)
            textColorNormal = UIColor.white
            textColorHighlighted = UIColor.lightGray
        } else {
            buttonBackground = UIColor.white
            viewBackground = UIColor(red:0.82, green:0.84, blue:0.86, alpha:1.0)
            utilBackgroundColor = UIColor(red:0.67, green:0.70, blue:0.73, alpha:1.0)
            textColorNormal = UIColor.darkGray
            textColorHighlighted = UIColor.black
            makeButtonBiggerTextColor = UIColor.black
            makeButtonBiggerBackground = UIColor(red:0.90, green:0.89, blue:0.89, alpha:1.0)
        }*/
    }
    
    // GPButtonEventsDelegate
    func moveCursor(numberOfMovement: Int) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.adjustTextPosition(byCharacterOffset: numberOfMovement)
    }
}
