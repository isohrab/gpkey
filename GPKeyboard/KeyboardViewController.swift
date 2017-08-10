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
          Harf.init(name: "sefr",face: "۰", output: "۰", returnable: false, spaceReturnable: false),
          Harf.init(name: "mosbat",face: "=", output: "=", returnable: false, spaceReturnable: false)],
         
         //second Row:
            [Harf.init(name: "prime",face: "`", output: "`", returnable: false, spaceReturnable: false),
             Harf.init(name: "mad",face: "~", output: "~", returnable: false, spaceReturnable: false),
             Harf.init(name: "bala",face: "^", output: "^", returnable: false, spaceReturnable: false),
             Harf.init(name: "dollar",face: "$", output: "$", returnable: false, spaceReturnable: false),
             Harf.init(name: "euro",face: "€", output: "€", returnable: false, spaceReturnable: false),
             Harf.init(name: "star",face: "*", output: "*", returnable: false, spaceReturnable: false),
             Harf.init(name: "darsad",face: "٪", output: "٪", returnable: false, spaceReturnable: false),
             Harf.init(name: "mosbat",face: "+", output: "+", returnable: false, spaceReturnable: false),
             Harf.init(name: "menha", face: "-",output: "-", returnable: false, spaceReturnable: false),
             Harf.init(name: "zarb",face: "×", output: "×", returnable: false, spaceReturnable: false),
             Harf.init(name: "taghsim",face: "÷", output: "÷", returnable: false, spaceReturnable: false)],
            
            //third Row:
            [Harf.init(name: "number-seperator",face: ",", output: ",", returnable: false, spaceReturnable: false),
             Harf.init(name: "register",face: ".", output: ".", returnable: false, spaceReturnable: false),
             Harf.init(name: "Copyright",face: ":", output: ":", returnable: false, spaceReturnable: false),
             Harf.init(name: "kama",face: "،", output: "،", returnable: false, spaceReturnable: false),
             Harf.init(name: "small",face: "<", output: ">", returnable: false, spaceReturnable: false),
             Harf.init(name: "great",face: ">", output: "<", returnable: false, spaceReturnable: false),
             Harf.init(name: "pipe",face: "|", output: "|", returnable: false, spaceReturnable: false),
             Harf.init(name: "parantezL",  face: "\u{0028}",   output: "\u{0028}", returnable: false, spaceReturnable: false),
             Harf.init(name: "parantezR",  face: "\u{0029}",   output: "\u{0029}", returnable: false, spaceReturnable: false),],
            
            // fourht row:
            [Harf.init(name: "back-slash",face: "\\", output: "\\", returnable: false, spaceReturnable: false),
             Harf.init(name: "slash",face: "/", output: "/", returnable: false, spaceReturnable: false),]]]
    
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
    var buttonHeight: CGFloat = 52
    var dmpPatriot: CGFloat = 1
    var marginTop:CGFloat = 0     // in iPad screen it should be multiply by 2
    
    var shift: Bool = false          // show state of shift button
    {
        didSet {
            doShift(shifting: shift)
        }
    }
    
    var returnAfterSpace = false {
        didSet {
            if returnAfterSpace == true
            {
                alefbaButtons[emojiState + 3][3].label?.text = "فاصله"
                alefbaButtons[emojiState + 3][3].type = .SPACE
            }
        }
    }
    
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
    var numberLayout: UIView!
    
    var alefbaButtons: [[GPButton]]!
    var numberButtons: [[GPButton]]!
    
    var portraitConstraints:[NSLayoutConstraint]!
    var landscapeConstraints:[NSLayoutConstraint]!
    
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
        
//        // setup tap detection for background view
//        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
//        tap.numberOfTouchesRequired = 1
//        tap.numberOfTapsRequired = 1
//        alefbaLayout.addGestureRecognizer(tap)
        
        alefbaButtons = [[GPButton]]()

        // check user setting if he wants to use emojies
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
        
        // Add character buttons
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
//                btn.isExclusiveTouch = true
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
        deleteButton.label?.text = ""
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
        globeButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .touchUpInside)
        
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
        sizeConstraints(buttons: alefbaButtons, kbLayout: alefbaLayout)
        positionConstraints(buttons: alefbaButtons, kbLayout: alefbaLayout)
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
        
        // check user setting if he want to use emojies
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
        globeButton.addTarget(self, action: #selector(advanceToNextInputMode), for: .touchUpInside)
        
        let spaceButton = GPButton(with: .SPACE)
        spaceButton.label?.text = "فاصله"
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
        sizeConstraints(buttons: numberButtons, kbLayout: numberLayout)
        positionConstraints(buttons: numberButtons, kbLayout: numberLayout)
        
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
            if shift == true
            {
                if returnAfterSpace == true
                {
                    shift = false
                    returnAfterSpace = false
                }
            }
            break
        case .GLOBE:
            self.advanceToNextInputMode()
            break
        case .SHIFT:
            playSound(for: utilSound)
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
            if shift == true
            {
                shift = false
            }
            break
        case .ENTER:
            playSound(for: utilSound)
            proxy.insertText("\n")
            break
        case .HALBSPACE:
            playSound(for: utilSound)
            proxy.insertText("\u{200C}")
            shift = false
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
            alefbaButtons[emojiState + 3][3].type = .HALBSPACE
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
            alefbaButtons[emojiState + 3][3].type = .SPACE

        }
    }
    func shiftManager(sender: GPButton)
    {
        if shift == true {
            let type = sender.type!
            if type == .CHAR
            {
                if let h = sender.harf
                {
                    if h.returnable == true
                    {
                        sender.Highlighting(state: false)
                        shift = false
                        return
                    }
                    if h.spaceReturnable == true
                    {
                        returnAfterSpace = true
                    }
                }
            }
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
        shiftManager(sender: sender)
    }
    
    func emojiTouched(_ sender: GPButton)
    {
        playSound(for: charSound)
        let proxy = textDocumentProxy as UITextDocumentProxy
        guard let char = sender.label?.text else {return}
        proxy.insertText(char)
        if shift == true
        {
            returnAfterSpace = true
        }
    }


    func playSound(for type:UInt32)
    {
        // mute mode
        if SoundState == 0
        {
            return  // hisssss! >:/
        }
        
        // vibrate mode
        if SoundState == 1
        {
            AudioServicesPlaySystemSound(vibSound)
            return
        }
        
        AudioServicesPlaySystemSound(type)
    }
    
    
    
    
    //////////// constraints functions:    ///////////
    func positionConstraints(buttons: [[GPButton]], kbLayout: UIView)
    {
        // chaining all first column to top and botton of each other vertically.
        for row in 0..<buttons.count-1
        {
            NSLayoutConstraint(item: buttons[row][0], attribute: .bottom, relatedBy: .equal, toItem: buttons[row+1][0], attribute: .top, multiplier: 1, constant: 0).isActive = true
        }
        // chain first button to top of the keyboard layer
        NSLayoutConstraint(item: buttons[0][0], attribute: .top, relatedBy: .equal, toItem: kbLayout, attribute: .top, multiplier: 1, constant: 0).isActive = true
        // chain the last button to top of the keyboard layer
        NSLayoutConstraint(item: buttons[buttons.count-1][0], attribute: .bottom, relatedBy: .equal, toItem: kbLayout, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        // chaining all buttons in a row from left to right of each other horizontally.
        for row in 0..<buttons.count
        {
            for col in 1..<buttons[row].count
            {
                NSLayoutConstraint(item: buttons[row][col-1], attribute: .right, relatedBy: .equal, toItem: buttons[row][col], attribute: .left, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: buttons[row][col-1], attribute: .centerY, relatedBy: .equal, toItem: buttons[row][col], attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            }
        }
        for row in 0..<buttons.count
        {
            NSLayoutConstraint(item: buttons[row][0], attribute: .left, relatedBy: .equal, toItem: kbLayout, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: buttons[row][buttons[row].count-1], attribute: .right, relatedBy: .equal, toItem: kbLayout, attribute: .right, multiplier: 1, constant: 0).isActive = true

        }
    }
    
    func sizeConstraints(buttons: [[GPButton]], kbLayout: UIView)
    {
        let muster = buttons[1][1]
        let np = NSLayoutConstraint(item: muster, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: buttonHeight)
        np.priority = 999
        portraitConstraints.append(np)
        
        let nl = NSLayoutConstraint(item: muster, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: buttonHeight * 0.8)
        nl.priority = 999
        landscapeConstraints.append(nl)
        
        for row in 0..<buttons.count
        {
            for col in 0..<buttons[row].count
            {
                let type = buttons[row][col].type!
                
                // all buttons should have same height (except emoji buttons)
                if type != .EMOJI
                {
                    NSLayoutConstraint(item: buttons[row][col], attribute: .height, relatedBy: .equal, toItem: muster, attribute: .height, multiplier: 1, constant: 0).isActive = true
                }
                
                // assign width constraint to buttons according to its characteristic
                switch type
                {
                case .CHAR:
                    NSLayoutConstraint(item: buttons[row][col], attribute: .width, relatedBy: .equal, toItem: muster, attribute: .width, multiplier: 1, constant: 0).isActive = true
                    break
                    
                case .EMOJI:
                    // the width is always equal to muster
                    // Portrait
                    portraitConstraints.append(NSLayoutConstraint(item: buttons[row][col], attribute: .height, relatedBy: .equal, toItem: muster, attribute: .width, multiplier: 1.3, constant: 0))
                    // Landscape
                    landscapeConstraints.append(NSLayoutConstraint(item: buttons[row][col], attribute: .height, relatedBy: .equal, toItem: muster, attribute: .height, multiplier: 0.8, constant: 0))
                    
                    NSLayoutConstraint(item: buttons[row][col], attribute: .width, relatedBy: .equal, toItem: muster, attribute: .width, multiplier: 1, constant: 0).isActive = true
                    break
                    
                case .SHIFT, .DELETE:
                    NSLayoutConstraint(item: buttons[row][col], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: muster, attribute: .width, multiplier: 1.5, constant: 0).isActive = true
                    break
                    
                case .ENTER:
                    NSLayoutConstraint(item: buttons[row][col], attribute: .width, relatedBy: .equal, toItem: muster, attribute: .width, multiplier: 1.75, constant: 0).isActive = true
                    break
                    
                case .SPACE, .HALBSPACE:
                    NSLayoutConstraint(item: buttons[row][col], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: muster, attribute: .width, multiplier: 3.5, constant: 0).isActive = true
                    break
                    
                case .GLOBE, .NUMBER:
                    NSLayoutConstraint(item: buttons[row][col], attribute: .width, relatedBy: .equal, toItem: muster, attribute: .width, multiplier: 1.25, constant: 0).isActive = true
                    break
                }
            }
        }
    }
    
    

    /****************************************
     *                                       *
     *   System default function             *
     *                                       *
     ****************************************/
    override func updateViewConstraints()
    {
        super.updateViewConstraints()
        // Activate constraints according device orientation
        if UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }
        else
        {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        

    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
            
        }
        else
        {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
            
        }
//            self.updateViewConstraints()
            self.view.updateConstraintsIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        
        setTheme()
        
        // initial landscape and portrait constraints
        landscapeConstraints = [NSLayoutConstraint]()
        portraitConstraints = [NSLayoutConstraint]()
        /**** initial Alefba layer    ****/
        alefbaLayout = UIView()
        alefbaLayout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(alefbaLayout)
        alefbaLayout.topAnchor.constraint(equalTo: self.view.topAnchor, constant: marginTop).isActive = true
        alefbaLayout.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        alefbaLayout.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        alefbaLayout.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        initAlefbaLayout()
        alefbaLayout.layer.opacity = 1
        
        /*** Initial Number Layer  ***/
        numberLayout = UIView()
        numberLayout.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(numberLayout)
        numberLayout.topAnchor.constraint(equalTo: self.view.topAnchor, constant: marginTop).isActive = true
        numberLayout.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        numberLayout.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        numberLayout.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        initNumberLayout()
        numberLayout.layer.opacity = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        self.view.setNeedsDisplay()
        self.updateViewConstraints()
        self.view.updateConstraintsIfNeeded()
    }

    func calculateVariables()
    {
        // define a default multiplier based iphone 6/6s/7 (width = 375) screen size.
        if UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        {
            dmpPatriot = UIScreen.main.bounds.size.width / 375
        }
        else
        {
            dmpPatriot = UIScreen.main.bounds.size.width / 667
        }
        
        gapHorizontal = gapHorizontal * dmpPatriot
        
        if dmpPatriot < 1
        {
            gapVertical = gapVertical / dmpPatriot
        }
        else
        {
            gapVertical = gapVertical * dmpPatriot
            buttonHeight = buttonHeight * dmpPatriot
        }
        
        marginTop = marginTop * dmpPatriot
        
        if emojiState == 0
        {
            marginTop = buttonHeight * 0.8
        }
    }
    override func textDidChange(_ textInput: UITextInput?) {
        //The app has just changed the document's contents, the document context has been updated.
        setTheme()
    }
    
    // GPButtonEventsDelegate
    func moveCursor(numberOfMovement: Int) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.adjustTextPosition(byCharacterOffset: numberOfMovement)
    }
    
    func setTheme()
    {
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            
            viewBackground = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
            
            GPButton.buttonColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0)
            GPButton.buttonHighlighted = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0)
            GPButton.utilBackgroundColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.0)
            GPButton.charColor = UIColor.white
            GPButton.shadowColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
            GPButton.layoutColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
            
        } else {
            viewBackground = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
            
            GPButton.buttonColor = UIColor.white
            GPButton.buttonHighlighted = UIColor.white
            GPButton.utilBackgroundColor = UIColor(red:0.67, green:0.70, blue:0.73, alpha:1.0)
            GPButton.charColor = UIColor.black
            GPButton.shadowColor = UIColor(red:0.54, green:0.55, blue:0.56, alpha:1.0)
            GPButton.layoutColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
        }
    }
}
