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

class KeyboardViewController: UIInputViewController {
    
    var tapSound: SystemSoundID = 1104
    let topSound: SystemSoundID = 1105
    let vibSound: SystemSoundID = 1520
    var soundID: Int = 0
    /****************************
     *   define alphabet value   *
     ****************************/
    struct Alefba {
        let Seda: String
        let value: Character
    }
    

    // [layer][row][column]
    let alphabets :[[[Alefba]]]=[[[
        // first layer: first row:
        Alefba.init(Seda: "zad", value: "ض"),
        Alefba.init(Seda: "sad", value: "ص"),
        Alefba.init(Seda: "ghaf", value: "ق"),
        Alefba.init(Seda: "fe", value: "ف"),
        Alefba.init(Seda: "ghein", value: "غ"),
        Alefba.init(Seda: "ein", value: "ع"),
        Alefba.init(Seda: "ha", value: "ه"),
        Alefba.init(Seda: "khe", value: "خ"),
        Alefba.init(Seda: "he", value: "ح"),
        Alefba.init(Seda: "je", value: "ج"),
        Alefba.init(Seda: "che", value: "چ")],
                                  
                                  //first Layer, Second Row:
        [Alefba.init(Seda: "she", value: "ش"),
         Alefba.init(Seda: "se", value: "س"),
         Alefba.init(Seda: "ye", value: "ی"),
         Alefba.init(Seda: "be", value: "ب"),
         Alefba.init(Seda: "lam", value: "ل"),
         Alefba.init(Seda: "alef", value: "ا"),
         Alefba.init(Seda: "te", value: "ت"),
         Alefba.init(Seda: "non", value: "ن"),
         Alefba.init(Seda: "mim", value: "م"),
         Alefba.init(Seda: "ke", value: "ک"),
         Alefba.init(Seda: "ge", value: "گ")],
        
        //first Layer, Third Row:
        [Alefba.init(Seda: "za", value: "ظ"),
         Alefba.init(Seda: "ta", value: "ط"),
         Alefba.init(Seda: "ze", value: "ز"),
         Alefba.init(Seda: "re", value: "ر"),
         Alefba.init(Seda: "zal", value: "ذ"),
         Alefba.init(Seda: "dal", value: "د"),
         Alefba.init(Seda: "pe", value: "پ"),
         Alefba.init(Seda: "ve", value: "و")],
        
        // first Layer, Fourth Row:
        [Alefba.init(Seda: "se3noghte", value: "ث"),
         Alefba.init(Seda: "zhe", value: "ژ")]],
                                 
        // Shift LAYER
        // Second Layer: first Row:
        [[Alefba.init(Seda: "saken", value: "ْ"),
          Alefba.init(Seda: "o", value: "ُ"),
          Alefba.init(Seda: "e", value: "ِ"),
          Alefba.init(Seda: "a", value: "َ"),
          Alefba.init(Seda: "an", value: "ً"),
          Alefba.init(Seda: "parantezL", value: "\u{0028}"),
          Alefba.init(Seda: "parantezR", value: "\u{0029}"),
          Alefba.init(Seda: "akoladL", value: "\u{007B}"),
          Alefba.init(Seda: "akoladR", value: "\u{007D}"),
          Alefba.init(Seda: "beraketL", value: "\u{005b}"),
          Alefba.init(Seda: "beraketR", value: "\u{005d}")],
         
         // second Layer, Second Row:
            [Alefba.init(Seda: "bullet", value: "•"),
             Alefba.init(Seda: "underline", value: "_"),
             Alefba.init(Seda: "yeHamze", value: "ئ"),
             Alefba.init(Seda: "tashdid", value: "\u{0651}"),
             Alefba.init(Seda: "hamze", value: "ء"),
             Alefba.init(Seda: "abakola", value: "آ"),
             Alefba.init(Seda: "keshidan", value: "ـ"),
             Alefba.init(Seda: "2fleshL", value: "\u{00ab}"),
             Alefba.init(Seda: "2fleshR", value: "\u{00bb}"),
             Alefba.init(Seda: "apostroph", value: "'"),
             Alefba.init(Seda: "quotation", value: "\"")],
            
            //second layer, third Row:
            [Alefba.init(Seda: "noghte", value: "."),
             Alefba.init(Seda: "virgol", value: "،"),
             Alefba.init(Seda: "3noghte", value: "\u{2026}"),
             Alefba.init(Seda: "donoghte", value: ":"),
             Alefba.init(Seda: "semicolon", value: "؛"),
             Alefba.init(Seda: "centigrad", value: "°"),
             Alefba.init(Seda: "soal", value: "؟"),
             Alefba.init(Seda: "tajob", value: "!")],
            
            // second layer, fourth Row:
            [Alefba.init(Seda: "atsign", value: "@"),
             Alefba.init(Seda: "sharp", value: "#")]],
        
        //Number layer
        // first Row:
        [[Alefba.init(Seda: "yek", value: "۱"),
          Alefba.init(Seda: "do", value: "۲"),
          Alefba.init(Seda: "se", value: "۳"),
          Alefba.init(Seda: "char", value: "۴"),
          Alefba.init(Seda: "panj", value: "۵"),
          Alefba.init(Seda: "shesh", value: "۶"),
          Alefba.init(Seda: "haft", value: "۷"),
          Alefba.init(Seda: "hasht", value: "۸"),
          Alefba.init(Seda: "noh", value: "۹"),
          Alefba.init(Seda: "sefr", value: "۰")],
         
         //second Row:
            [Alefba.init(Seda: "mad", value: "~"),
             Alefba.init(Seda: "bala", value: "^"),
             Alefba.init(Seda: "dollar", value: "$"),
             Alefba.init(Seda: "star", value: "*"),
             Alefba.init(Seda: "darsad", value: "٪"),
             Alefba.init(Seda: "mosavi", value: "="),
             Alefba.init(Seda: "mosbat", value: "+"),
             Alefba.init(Seda: "menha", value: "-"),
             Alefba.init(Seda: "zarb", value: "×"),
             Alefba.init(Seda: "taghsim", value: "÷")],
            
            //third Row:
            [Alefba.init(Seda: "prime", value: "`"),
             Alefba.init(Seda: "coma-pool", value: "،"),
             Alefba.init(Seda: "euro", value: "€"),
             Alefba.init(Seda: "register", value: "."),
             Alefba.init(Seda: "Copyright", value: ":"),
             Alefba.init(Seda: "small", value: "<"),
             Alefba.init(Seda: "great", value: ">"),
             Alefba.init(Seda: "pipe", value: "|")],
            
            // fourht row:
            [Alefba.init(Seda: "slash", value: "/"),
             Alefba.init(Seda: "backslash", value: "\\")]]]
    
    // the smiles are changable in main App
    var smile:String =  "\u{1F600}\u{1F601}\u{1F602}\u{1F60E}\u{1F60D}\u{1F618}\u{0263A}\u{1F61C}\u{1F914}\u{1F339}\u{02764}\u{1F610}\u{1F61E}\u{1F62D}\u{1F633}\u{1F631}\u{1F620}\u{1F621}\u{1F382}\u{1F381}\u{1F38A}\u{1F494}"
    /*************************************
     *                                    *
     *   Define Global Value              *
     *   - keyboards layers               *
     *   - keyboard dimension and points  *
     *                                    *
     *************************************/
    var keyboardWidth: CGFloat = 0    // should be calculated according to UIScreen
    var keyboardHeight: CGFloat = 0   // should be calculated according to UIScreen
    var keyboardHeightLandscape:CGFloat = 0 // should be calculated according to UIScreen
    var keyboardWidthLandscape:CGFloat = 0  // should be calculated according to UIScreen
    var gapHorizontal: CGFloat = 2.5    // in iPad screens should be multiply by 2
    var gapVertical: CGFloat = 4        // in iPad Screen should be multiply by 2
    var alefbaButtonWidth: CGFloat = 0  // should be calculated according to UIScreen
    var alefbaButtonHeight: CGFloat = 0 // should be calculated according to UIScreen
    var marginRight:CGFloat = 1.75  // in iPad screen it should be multiply by 2
    var marginTop:CGFloat = 1.5     // in iPad screen it should be multiply by 2
    var shift: Bool = false         // show state of shift button
    var currentLayout: Int = 0
    var deleting: Bool = false  // when it is true, continuing deleting characters
    var deleteTimer: TimeInterval = 0.3    // it will accelerate deleting upto 500 milisecond
    var timer:Timer!
    var aButtonTouched:Bool = false
    
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
    /*******    Keyboard layers     *********/
    
    let mainViewPortrait: UIView = UIView()
    let shiftViewPortrait: UIView = UIView()
    let numberViewPortrait: UIView = UIView()
    var mainViewLandscape: UIView = UIView()
    let shiftViewLandscape:UIView = UIView()
    let numberViewLandscape:UIView = UIView()
    // show alphabet above the touched button
    var shower:UILabel = UILabel()
    var lastTouchedButton: UIButton!
    
    /****************************************
     *                                       *
     *   Main function to initial keyboard   *
     *                                       *
     ****************************************/
    
    func initAlefba(){
        // TODO: background should be checked here
        mainViewPortrait.backgroundColor = viewBackground
        
        // setup tap detection for background view
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        tap.requiresExclusiveTouchType = false
        mainViewPortrait.addGestureRecognizer(tap)
        
        
        gapVertical = 6
        gapHorizontal = 4
        marginRight = 1.75  // in iPad screen it should be multiply by 2
        marginTop = 1.5
        // calculate values that need to put the buttons on the layer based different UIScreens sizes
        alefbaButtonWidth = (keyboardWidth - ((10 * gapHorizontal) + (2 * marginRight))) / 11
        
        // read user setting if smilies are ON
        // calculate the heigh of buttons
        var isSmileOn:CGFloat = 0
        let prefs = UserDefaults(suiteName: "group.me.alirezak.gpkeys")
        let emojiState = prefs?.integer(forKey: "emojiState")
        if emojiState == 1
        {
            alefbaButtonHeight = (keyboardHeight - ((4 * gapVertical) + (2 * marginTop) + alefbaButtonWidth)) / 4
            isSmileOn = 1
        }
        else
        {
            gapVertical *= 2
            marginTop *= 4
            gapHorizontal *= 1.2
            alefbaButtonHeight = (keyboardHeight - ((3 * gapVertical) + (2 * marginTop))) / 4
            alefbaButtonWidth = (keyboardWidth - ((10 * gapHorizontal) + (2 * marginRight))) / 11
            isSmileOn = 0
        }
        
        
        
        
        /*****************************************
         *                                        *
         *   initial Smily row                    *
         *                                        *
         *****************************************/
        // check user setting if he want to use smily. Also

        if emojiState == 1
        {
            for i in 0...10
            {
                let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                               y: marginTop,
                               width: alefbaButtonWidth,
                               height: alefbaButtonWidth)
                var b:UIButton!
                let emojiInt = prefs?.integer(forKey: String(i))
                if emojiInt != 0
                {
                    b = createButton(rect: r, char: Character(UnicodeScalar(emojiInt!)!))
                }
                else
                {
                    b = createButton(rect: r, char: toChar(s: smile, i: i))
                }
                b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
                b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
                b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
                b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
                
                mainViewPortrait.addSubview(b)

            }
        }
        
        /*****************************************
         *                                        *
         *   initial first alfabet row            *
         *                                        *
         *****************************************/
        
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + (isSmileOn * (alefbaButtonWidth + gapVertical)),
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            let b: UIButton = createButton(rect: r, char: alphabets[0][0][i].value)

            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            mainViewPortrait.addSubview(b)

        }
        /*****************************************
         *                                        *
         *   initial second alfabet row           *
         *                                        *
         *****************************************/
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + (isSmileOn * (alefbaButtonWidth + gapVertical)) + gapVertical + alefbaButtonHeight,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[0][1][i].value)
            
            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            mainViewPortrait.addSubview(b)
        }
        
        /*****************************************
         *                                        *
         *   initial third alfabet row            *
         *                                        *
         *****************************************/
        
        // initial Shift button
        var r = CGRect( x: marginRight ,
                        y: marginTop + (2 * (gapVertical + alefbaButtonHeight)) + (isSmileOn * (alefbaButtonWidth + gapVertical)),
                        width: alefbaButtonWidth * 1.5,
                        height: alefbaButtonHeight)
        
        let shiftb = createUtilButton(rect: r, withTarget: true)
        shiftb.tag = 1
        mainViewPortrait.addSubview(shiftb)

        
        // initial alefba
        for i in 0...7
        {
            let startX = shiftb.frame.maxX + ((gapHorizontal * 3) / 2)
            r = CGRect( x: startX + (CGFloat(i) * (gapHorizontal + alefbaButtonWidth)),
                        y: shiftb.layer.frame.minY,
                        width: alefbaButtonWidth,
                        height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[0][2][i].value)
            
            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            mainViewPortrait.addSubview(b)
        }
        
        // initial delete button
        r = CGRect( x: keyboardWidth - (marginRight + shiftb.frame.width),
                    y: shiftb.layer.frame.minY,
                    width: shiftb.frame.width ,
                    height: alefbaButtonHeight)
        let deleteButton = createUtilButton(rect: r, withTarget: false)
        deleteButton.tag = 3
        deleteButton.addTarget(self, action: #selector(self.utilTouched), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUpOutside), for: .touchUpOutside)
        mainViewPortrait.addSubview(deleteButton)
        
        /*****************************************
         *                                        *
         *   initial fourth alfabet row           *
         *                                        *
         *****************************************/
        // initial 123 button
        r = CGRect( x: marginRight,
                    y: keyboardHeight - (alefbaButtonHeight + marginTop),
                    width: alefbaButtonWidth * 1.25 ,
                    height: alefbaButtonHeight)
        let numberButton = createUtilButton(rect: r, withTarget: true)
        numberButton.setTitle("۱۲۳", for: UIControlState())
        numberButton.tag = 2
        mainViewPortrait.addSubview(numberButton)

        
        // Initial next button layer
        r = CGRect(x: marginRight + numberButton.frame.width + gapHorizontal ,
                   y: numberButton.frame.minY,
                   width: numberButton.frame.width ,
                   height: alefbaButtonHeight)
        let nextKeyboardButton = createUtilButton(rect: r, withTarget: true)
        nextKeyboardButton.tag = 99
        mainViewPortrait.addSubview(nextKeyboardButton)
        
        // initial left  button
        r = CGRect( x: nextKeyboardButton.frame.maxX + gapHorizontal,
                    y: numberButton.layer.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)

        let leftButton: UIButton = createButton(rect: r, char: alphabets[0][3][0].value)
        
        leftButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        mainViewPortrait.addSubview(leftButton)
        
        // initial Space button
        r = CGRect( x: leftButton.frame.maxX + gapHorizontal,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth * 4.5 ,
                    height: alefbaButtonHeight)
        let spaceButton=createUtilButton(rect: r, withTarget: false)
        spaceButton.setTitle("فاصله", for: UIControlState())
        spaceButton.tag = 32
        spaceButton.backgroundColor = buttonBackground
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        mainViewPortrait.addSubview(spaceButton)
        
        // initial Right button
        r = CGRect( x: spaceButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight  )
        let rightButton: UIButton = createButton(rect: r, char: alphabets[0][3][1].value)
        
        rightButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        mainViewPortrait.addSubview(rightButton)
        
        // initial Enter Button
        // calculate width for Enter to fill remined space
        let w = keyboardWidth - ((9 * alefbaButtonWidth) + marginRight + (6 * gapHorizontal))
        r = CGRect( x: keyboardWidth - (w + marginRight) ,
                                          y: numberButton.frame.minY,
                                          width: w ,
                                          height: alefbaButtonHeight)
        
        let EnterButton = createUtilButton(rect: r, withTarget: true)
        EnterButton.tag = 13
        mainViewPortrait.addSubview(EnterButton)
        
        // change icons to white color if apperiance is dark
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            shiftb.setImage(UIImage(named: "shiftW"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteW"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "langW"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enterW"), for: UIControlState.normal)
            
            shiftb.layer.shadowOpacity = 0
            deleteButton.layer.shadowOpacity = 0
            nextKeyboardButton.layer.shadowOpacity = 0
            EnterButton.layer.shadowOpacity = 0
            numberButton.layer.shadowOpacity = 0
        }
        else {
            shiftb.setImage(UIImage(named: "shiftUp"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteUp"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "lang"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enter"), for: UIControlState.normal)
        }
        
        // make tag to 1: it means we initialized main layer
        mainViewPortrait.tag = 1
        mainViewPortrait.isMultipleTouchEnabled = false
        // END OF ALEFBA LAYER
        
    }
    
    
    
    
    // initial Shift Portrait
    func initShift(){

        // TODO: background should be checked here
        shiftViewPortrait.backgroundColor = viewBackground
        
        // setup tap detection for background view
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        shiftViewPortrait.addGestureRecognizer(tap)
        
        gapVertical = 6
        gapHorizontal = 4
        marginRight = 1.75  // in iPad screen it should be multiply by 2
        marginTop = 1.5
        // calculate values that need to put the buttons on the layer based different UIScreens sizes
        alefbaButtonWidth = (keyboardWidth - ((10 * gapHorizontal) + (2 * marginRight))) / 11
        
        // read user setting if enabled emojis : default is ON
        let prefs = UserDefaults(suiteName: "group.me.alirezak.gpkeys")
        let emojiState = prefs?.integer(forKey: "emojiState")
        var isSmileOn:CGFloat = 0
        if emojiState == 1
        {
            alefbaButtonHeight = (keyboardHeight - ((4 * gapVertical) + (2 * marginTop) + alefbaButtonWidth)) / 4
            isSmileOn = 1
        }
        else
        {
            gapVertical *= 2
            marginTop *= 4
            gapHorizontal *= 1.2
            alefbaButtonHeight = (keyboardHeight - ((3 * gapVertical) + (2 * marginTop))) / 4
            alefbaButtonWidth = (keyboardWidth - ((10 * gapHorizontal) + (2 * marginRight))) / 11
            isSmileOn = 0
        }
        
        
        
        
        /*****************************************
         *                                        *
         *   initial Smily row                    *
         *                                        *
         *****************************************/
        // if user want emojis, we show them! :)
        if emojiState == 1
        {
            for i in 0...10
            {
                let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                               y: marginTop,
                               width: alefbaButtonWidth,
                               height: alefbaButtonWidth)
                var b:UIButton!
                let emojiInt = prefs?.integer(forKey: String(i + 11))
                if emojiInt != 0
                {
                    b = createButton(rect: r, char: Character(UnicodeScalar(emojiInt!)!))
                }
                else
                {
                    b = createButton(rect: r, char: toChar(s: smile, i: i+11))
                }
                b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
                b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
                b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
                b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
                
                shiftViewPortrait.addSubview(b)
                
            }
        }
        
        /*****************************************
         *                                        *
         *   initial first  row                   *
         *                                        *
         *****************************************/
        // we need these buttons for further manipulation!
        var buttons: [UIButton] = [UIButton]()
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + (isSmileOn * (alefbaButtonWidth + gapVertical)),
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            let b: UIButton = createButton(rect: r, char: alphabets[1][0][i].value)

            b.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            shiftViewPortrait.addSubview(b)
            buttons.append(b)
        }
        
        // now change the action in touchUpInside for () {} []
        for i in 5...10
        {
            buttons[i].removeTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        }
        for i in 5...10
        {
            buttons[i].addTarget(self, action: #selector(self.signButtonTouched(_:)), for: .touchUpInside)
        }
        // set text color a, o, e, sokun character like background
        for i in 0...4
        {
            buttons[i].setTitleColor(buttonBackground, for: .normal)
        }
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            buttons[0].setImage(UIImage(named: "sokunW"), for: UIControlState())
            buttons[1].setImage(UIImage(named: "oW"), for: UIControlState())
            buttons[2].setImage(UIImage(named: "aW"), for: UIControlState())
            buttons[3].setImage(UIImage(named: "aW"), for: UIControlState())
            buttons[4].setImage(UIImage(named: "anW"), for: UIControlState())
        }
        else {
            buttons[0].setImage(UIImage(named: "sokun"), for: UIControlState())
            buttons[1].setImage(UIImage(named: "oo"), for: UIControlState())
            buttons[2].setImage(UIImage(named: "aa"), for: UIControlState())
            buttons[3].setImage(UIImage(named: "aa"), for: UIControlState())
            buttons[4].setImage(UIImage(named: "aan"), for: UIControlState())
        }
        
        buttons[1].imageEdgeInsets = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        buttons[2].imageEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        buttons[3].imageEdgeInsets = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        buttons[4].imageEdgeInsets = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        
        
        
        
        /*****************************************
         *                                        *
         *   initial second alfabet row           *
         *                                        *
         *****************************************/
        // we need again to manipulate «» signs and tashdid
        buttons.removeAll()
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + (isSmileOn * (alefbaButtonWidth + gapVertical)) + gapVertical + alefbaButtonHeight,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[1][1][i].value)

            b.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            shiftViewPortrait.addSubview(b)
            buttons.append(b)
        }
        // now change the action in touchUpInside for «»
        buttons[7].removeTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        buttons[7].addTarget(self, action: #selector(self.signButtonTouched(_:)), for: .touchUpInside)
        buttons[8].removeTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        buttons[8].addTarget(self, action: #selector(self.signButtonTouched(_:)), for: .touchUpInside)
        
        // manipulate tashdid
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            buttons[3].setImage(UIImage(named: "tashdidW"), for: UIControlState())
        }
        else {
            buttons[3].setImage(UIImage(named: "tashdid"), for: UIControlState())
        }
        /*****************************************
         *                                        *
         *   initial third alfabet row            *
         *                                        *
         *****************************************/
        
        // initial Shift button
        var r = CGRect( x: marginRight ,
                        y: marginTop + (2 * (gapVertical + alefbaButtonHeight)) + (isSmileOn * (alefbaButtonWidth + gapVertical)),
                        width: alefbaButtonWidth * 1.5,
                        height: alefbaButtonHeight)
        
        let shiftb = createUtilButton(rect: r, withTarget: true)
        shiftb.tag = 1
        shiftViewPortrait.addSubview(shiftb)
        
        
        // initial alefba
        for i in 0...7
        {
            let startX = shiftb.frame.maxX + ((gapHorizontal * 3) / 2)
            r = CGRect( x: startX + (CGFloat(i) * (gapHorizontal + alefbaButtonWidth)),
                        y: shiftb.layer.frame.minY,
                        width: alefbaButtonWidth,
                        height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[1][2][i].value)

            b.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            shiftViewPortrait.addSubview(b)
        }
        
        // initial delete button
        r = CGRect( x: keyboardWidth - (marginRight + shiftb.frame.width),
                    y: shiftb.layer.frame.minY,
                    width: shiftb.frame.width ,
                    height: alefbaButtonHeight)
        let deleteButton = createUtilButton(rect: r, withTarget: false)
        deleteButton.tag = 3
        deleteButton.addTarget(self, action: #selector(self.utilTouched), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUpOutside), for: .touchUpOutside)
        shiftViewPortrait.addSubview(deleteButton)
        
        /*****************************************
         *                                        *
         *   initial fourth alfabet row           *
         *                                        *
         *****************************************/
        // initial 123 button
        r = CGRect( x: marginRight,
                    y: keyboardHeight - (alefbaButtonHeight + marginTop),
                    width: alefbaButtonWidth * 1.25 ,
                    height: alefbaButtonHeight)
        let numberButton = createUtilButton(rect: r, withTarget: true)
        numberButton.setTitle("۱۲۳", for: UIControlState())
        numberButton.tag = 2
        shiftViewPortrait.addSubview(numberButton)
        
        
        // Initial next button layer
        r = CGRect(x: marginRight + numberButton.frame.width + gapHorizontal ,
                   y: numberButton.frame.minY,
                   width: numberButton.frame.width ,
                   height: alefbaButtonHeight)
        let nextKeyboardButton = createUtilButton(rect: r, withTarget: true)
        nextKeyboardButton.tag = 99
        shiftViewPortrait.addSubview(nextKeyboardButton)
        
        // initial left  button
        r = CGRect( x: nextKeyboardButton.frame.maxX + gapHorizontal,
                    y: numberButton.layer.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)
        
        let leftButton: UIButton = createButton(rect: r, char: alphabets[1][3][0].value)
        
        leftButton.isExclusiveTouch = true
        leftButton.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        shiftViewPortrait.addSubview(leftButton)
        
        // initial Space button
        r = CGRect( x: leftButton.frame.maxX + gapHorizontal,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth * 4.5 ,
                    height: alefbaButtonHeight)
        let spaceButton=createUtilButton(rect: r, withTarget: false)
        spaceButton.setTitle("نیم فاصله", for: UIControlState())
        spaceButton.tag = 8204
        spaceButton.backgroundColor = buttonBackground
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        shiftViewPortrait.addSubview(spaceButton)
        
        // initial Right button
        r = CGRect( x: spaceButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight  )
        let rightButton: UIButton = createButton(rect: r, char: alphabets[1][3][1].value)
        
        rightButton.isExclusiveTouch = true
        rightButton.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        shiftViewPortrait.addSubview(rightButton)
        
        // initial Enter Button
        // calculate width for Enter to fill remined space
        let w = keyboardWidth - ((9 * alefbaButtonWidth) + marginRight + (6 * gapHorizontal))
        r = CGRect( x: keyboardWidth - (w + marginRight) ,
                    y: numberButton.frame.minY,
                    width: w ,
                    height: alefbaButtonHeight)
        
        let EnterButton = createUtilButton(rect: r, withTarget: true)
        EnterButton.tag = 13
        shiftViewPortrait.addSubview(EnterButton)
        
        // change icons to white color if apperiance is dark
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            shiftb.setImage(UIImage(named: "shiftW"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteW"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "langW"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enterW"), for: UIControlState.normal)
            
            shiftb.layer.shadowOpacity = 0
            deleteButton.layer.shadowOpacity = 0
            nextKeyboardButton.layer.shadowOpacity = 0
            EnterButton.layer.shadowOpacity = 0
            numberButton.layer.shadowOpacity = 0
        }
        else {
            shiftb.setImage(UIImage(named: "shiftUp"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteUp"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "lang"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enter"), for: UIControlState.normal)
        }
        
        // make tag to 1: it means we initialized main layer
        shiftViewPortrait.tag = 1
        shiftViewPortrait.isMultipleTouchEnabled = false
        // END OF ALEFBA LAYER
        
    }
    // INITIAL ALEFBA LANDSCAPE VIEW
    func initAlefbaLandscape() {
        // TODO: background should be checked here
        mainViewLandscape.backgroundColor = viewBackground
        
        // setup tap detection for background view
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        mainViewLandscape.addGestureRecognizer(tap)

        
        marginRight = 1.75  // in iPad screen it should be multiply by 2
        marginTop = 1.5
        // calculate values that need to put the buttons on the layer!
        gapVertical = 4
        gapHorizontal = 6
        alefbaButtonWidth = (keyboardWidthLandscape - ((10 * gapHorizontal) + (2 * marginRight))) / 11
        alefbaButtonHeight = (keyboardHeightLandscape - ((3 * gapVertical) + (2 * marginTop))) / 4
        
        
        /************************************************
         *                                              *
         *   initial Smily row                          *
         *   we can't use smilies in Landscape mode :(  *
         ***********************************************/
       
        
        /*****************************************
         *                                        *
         *   initial first alfabet row            *
         *                                        *
         *****************************************/
        
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop ,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            let b: UIButton = createButton(rect: r, char: alphabets[0][0][i].value)
            
            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            mainViewLandscape.addSubview(b)
            
        }
        /*****************************************
         *                                        *
         *   initial second alfabet row           *
         *                                        *
         *****************************************/
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + gapVertical + alefbaButtonHeight,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[0][1][i].value)
            
            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            mainViewLandscape.addSubview(b)
        }
        
        /*****************************************
         *                                        *
         *   initial third alfabet row            *
         *                                        *
         *****************************************/
        
        // initial Shift button
        var r = CGRect( x: marginRight ,
                        y: (2 * gapVertical) + (2 * alefbaButtonHeight) + marginTop,
                        width: alefbaButtonWidth * 1.5,
                        height: alefbaButtonHeight)
        
        let shiftb = createUtilButton(rect: r, withTarget: true)
        shiftb.tag = 1
        mainViewLandscape.addSubview(shiftb)
        
        
        // initial alefba
        let startX = marginRight + shiftb.frame.width + ((gapHorizontal * 3 )/2)
        for i in 0...7
        {
            r = CGRect( x: startX + (CGFloat(i) * (gapHorizontal + alefbaButtonWidth)),
                        y: shiftb.layer.frame.minY,
                        width: alefbaButtonWidth,
                        height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[0][2][i].value)

            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            mainViewLandscape.addSubview(b)
        }
        
        // initial delete button
        r = CGRect( x: keyboardWidthLandscape - (marginRight + shiftb.frame.width),
                    y: shiftb.layer.frame.minY,
                    width: alefbaButtonWidth * 1.5 ,
                    height: alefbaButtonHeight)
        let deleteButton = createUtilButton(rect: r, withTarget: false)
        deleteButton.tag = 3
        deleteButton.addTarget(self, action: #selector(self.utilTouched), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUpOutside), for: .touchUpOutside)
        mainViewLandscape.addSubview(deleteButton)
        
        /*****************************************
         *                                        *
         *   initial fourth alfabet row           *
         *                                        *
         *****************************************/
        // initial 123 button
        r = CGRect( x: marginRight + gapHorizontal + alefbaButtonWidth,
                    y: keyboardHeightLandscape - (alefbaButtonHeight + marginTop),
                    width: alefbaButtonWidth,
                    height: alefbaButtonHeight)
        let numberButton = createUtilButton(rect: r, withTarget: true)
        numberButton.setTitle("۱۲۳", for: UIControlState())
        numberButton.tag = 2
        mainViewLandscape.addSubview(numberButton)
        
        
        // Initial next button layer
        r = CGRect(x: numberButton.frame.maxX + gapHorizontal ,
                   y: numberButton.frame.minY,
                   width: alefbaButtonWidth ,
                   height: alefbaButtonHeight)
        let nextKeyboardButton = createUtilButton(rect: r, withTarget: true)
        nextKeyboardButton.tag = 99
        mainViewLandscape.addSubview(nextKeyboardButton)
        
        // initial left  button
        r = CGRect( x: nextKeyboardButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)
        
        let leftButton: UIButton = createButton(rect: r, char: alphabets[0][3][0].value)

        leftButton.isExclusiveTouch = true
        leftButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        mainViewLandscape.addSubview(leftButton)
        
        // initial Space button
        r = CGRect( x: leftButton.frame.maxX + gapHorizontal,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth * 4,
                    height: alefbaButtonHeight)
        let spaceButton=createUtilButton(rect: r, withTarget: false)
        spaceButton.setTitle("فاصله", for: UIControlState())
        spaceButton.tag = 32
        spaceButton.backgroundColor = buttonBackground
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        mainViewLandscape.addSubview(spaceButton)
        
        // initial Right button
        r = CGRect( x: spaceButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)
        let rightButton: UIButton = createButton(rect: r, char: alphabets[0][3][1].value)

        rightButton.isExclusiveTouch = true
        rightButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        mainViewLandscape.addSubview(rightButton)
        
        // initial Enter Button
        r = CGRect( x: rightButton.frame.maxX + gapHorizontal ,
                                          y: numberButton.frame.minY,
                                          width: alefbaButtonWidth * 1.5 ,
                                          height: alefbaButtonHeight)
        
        let EnterButton = createUtilButton(rect: r, withTarget: true)
        EnterButton.tag = 13
        mainViewLandscape.addSubview(EnterButton)
        
        // change icons to white color if apperiance is dark
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            shiftb.setImage(UIImage(named: "shiftW"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteW"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "langW"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enterW"), for: UIControlState.normal)
        }
        else {
            shiftb.setImage(UIImage(named: "shiftUp"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteUp"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "lang"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enter"), for: UIControlState.normal)
        }
        
        // make tag to 1: it means we initialized main layer
        mainViewLandscape.tag = 1
        mainViewLandscape.isMultipleTouchEnabled = false
        // END OF ALEFBA LAYER
    }
    
    // Inital shift layer for Landscape 
    // initial Shift Portrait
    func initShiftLandscape(){
        
        // TODO: background should be checked here
        shiftViewLandscape.backgroundColor = viewBackground
        
        // setup tap detection for background view
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        shiftViewLandscape.addGestureRecognizer(tap)
        
        marginRight = 1.75  // in iPad screen it should be multiply by 2
        marginTop = 1.5
        gapVertical = 4
        gapHorizontal = 6
        alefbaButtonWidth = (keyboardWidthLandscape - ((10 * gapHorizontal) + (2 * marginRight))) / 11
        alefbaButtonHeight = (keyboardHeightLandscape - ((3 * gapVertical) + (2 * marginTop))) / 4
        let isSmileOn:CGFloat = 0
        
        
        /************************************************
         *                                              *
         *   initial Smily row                          *
         *   we can't use smilies in Landscape mode :(  *
         ***********************************************/
        
        /*****************************************
         *                                        *
         *   initial first alfabet row            *
         *                                        *
         *****************************************/
        // we need these buttons for further manipulation!
        var buttons: [UIButton] = [UIButton]()
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + (isSmileOn * (alefbaButtonWidth + gapVertical)),
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            let b: UIButton = createButton(rect: r, char: alphabets[1][0][i].value)
            
            b.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            shiftViewLandscape.addSubview(b)
            buttons.append(b)
        }
        
        // now change the action in touchUpInside for () {} []
        for i in 5...10
        {
            buttons[i].removeTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        }
        for i in 5...10
        {
            buttons[i].addTarget(self, action: #selector(self.signButtonTouched(_:)), for: .touchUpInside)
        }
        // set text color for  a, o, e, sokun character as same as background to hide them!
        for i in 0...4
        {
            buttons[i].setTitleColor(buttonBackground, for: .normal)
        }
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            buttons[0].setImage(UIImage(named: "sokunW"), for: UIControlState())
            buttons[1].setImage(UIImage(named: "oW"), for: UIControlState())
            buttons[2].setImage(UIImage(named: "aW"), for: UIControlState())
            buttons[3].setImage(UIImage(named: "aW"), for: UIControlState())
            buttons[4].setImage(UIImage(named: "anW"), for: UIControlState())
        }
        else {
            buttons[0].setImage(UIImage(named: "sokun"), for: UIControlState())
            buttons[1].setImage(UIImage(named: "oo"), for: UIControlState())
            buttons[2].setImage(UIImage(named: "aa"), for: UIControlState())
            buttons[3].setImage(UIImage(named: "aa"), for: UIControlState())
            buttons[4].setImage(UIImage(named: "aan"), for: UIControlState())
        }

        buttons[1].imageEdgeInsets = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        buttons[2].imageEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        buttons[3].imageEdgeInsets = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        buttons[4].imageEdgeInsets = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        
        
        
        /*****************************************
         *                                        *
         *   initial second alfabet row           *
         *                                        *
         *****************************************/
        // we need again to manipulate «» signs and tashdid
        buttons.removeAll()
        for i in 0...10
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + (isSmileOn * (alefbaButtonWidth + gapVertical)) + gapVertical + alefbaButtonHeight,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[1][1][i].value)
            
            b.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            shiftViewLandscape.addSubview(b)
            buttons.append(b)
        }
        // now change the action in touchUpInside for «»
        buttons[7].removeTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        buttons[7].addTarget(self, action: #selector(self.signButtonTouched(_:)), for: .touchUpInside)
        buttons[8].removeTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        buttons[8].addTarget(self, action: #selector(self.signButtonTouched(_:)), for: .touchUpInside)
        
        // manipulate tashdid
        buttons[3].setImage(UIImage(named: "tashdid"), for: UIControlState())
        /*****************************************
         *                                        *
         *   initial third alfabet row            *
         *                                        *
         *****************************************/
        
        // initial Shift button
        var r = CGRect( x: marginRight ,
                        y: marginTop + (2 * (gapVertical + alefbaButtonHeight)) + (isSmileOn * (alefbaButtonWidth + gapVertical)),
                        width: alefbaButtonWidth * 1.5,
                        height: alefbaButtonHeight)
        
        let shiftb = createUtilButton(rect: r, withTarget: true)
        shiftb.tag = 1
        shiftViewLandscape.addSubview(shiftb)
        
        
        // initial alefba
        for i in 0...7
        {
            let startX = shiftb.frame.maxX + ((gapHorizontal * 3) / 2)
            r = CGRect( x: startX + (CGFloat(i) * (gapHorizontal + alefbaButtonWidth)),
                        y: shiftb.layer.frame.minY,
                        width: alefbaButtonWidth,
                        height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[1][2][i].value)

            b.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            shiftViewLandscape.addSubview(b)
        }
        
        // initial delete button
        r = CGRect( x: keyboardWidthLandscape - (marginRight + shiftb.frame.width),
                    y: shiftb.layer.frame.minY,
                    width: shiftb.frame.width ,
                    height: alefbaButtonHeight)
        let deleteButton = createUtilButton(rect: r, withTarget: false)
        deleteButton.tag = 3
        deleteButton.addTarget(self, action: #selector(self.utilTouched), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUpOutside), for: .touchUpOutside)
        shiftViewLandscape.addSubview(deleteButton)
        
        /*****************************************
         *                                        *
         *   initial fourth alfabet row           *
         *                                        *
         *****************************************/
        // initial 123 button
        r = CGRect( x: marginRight + gapHorizontal + alefbaButtonWidth,
                    y: keyboardHeightLandscape - (alefbaButtonHeight + marginTop),
                    width: alefbaButtonWidth,
                    height: alefbaButtonHeight)
        let numberButton = createUtilButton(rect: r, withTarget: true)
        numberButton.setTitle("۱۲۳", for: UIControlState())
        numberButton.tag = 2
        shiftViewLandscape.addSubview(numberButton)
        
        
        // Initial next button layer
        r = CGRect(x: numberButton.frame.maxX + gapHorizontal ,
                   y: numberButton.frame.minY,
                   width: alefbaButtonWidth ,
                   height: alefbaButtonHeight)
        let nextKeyboardButton = createUtilButton(rect: r, withTarget: true)
        nextKeyboardButton.tag = 99
        shiftViewLandscape.addSubview(nextKeyboardButton)
        
        // initial left  button
        r = CGRect( x: nextKeyboardButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)
        
        let leftButton: UIButton = createButton(rect: r, char: alphabets[1][3][0].value)

        leftButton.isExclusiveTouch = true
        leftButton.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        shiftViewLandscape.addSubview(leftButton)
        
        // initial Space button
        r = CGRect( x: leftButton.frame.maxX + gapHorizontal,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth * 4,
                    height: alefbaButtonHeight)
        let spaceButton=createUtilButton(rect: r, withTarget: false)
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        spaceButton.setTitle("نیم فاصله", for: UIControlState())
        spaceButton.tag = 8204
        spaceButton.backgroundColor = buttonBackground
        shiftViewLandscape.addSubview(spaceButton)
        
        // initial Right button
        r = CGRect( x: spaceButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)
        let rightButton: UIButton = createButton(rect: r, char: alphabets[1][3][1].value)

        rightButton.isExclusiveTouch = true
        rightButton.addTarget(self, action: #selector(self.shiftButtonTouched(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        shiftViewLandscape.addSubview(rightButton)
        
        // initial Enter Button
        // calculate width for Enter to fill remined space
        r = CGRect( x: rightButton.frame.maxX + gapHorizontal ,
                                          y: numberButton.frame.minY,
                                          width: alefbaButtonWidth * 1.5 ,
                                          height: alefbaButtonHeight)
        
        let EnterButton = createUtilButton(rect: r, withTarget: true)
        EnterButton.tag = 13
        shiftViewLandscape.addSubview(EnterButton)
        
        // change icons to white color if apperiance is dark
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            shiftb.setImage(UIImage(named: "shiftW"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteW"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "langW"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enterW"), for: UIControlState.normal)
            
            shiftb.layer.shadowOpacity = 0
            deleteButton.layer.shadowOpacity = 0
            nextKeyboardButton.layer.shadowOpacity = 0
            EnterButton.layer.shadowOpacity = 0
            numberButton.layer.shadowOpacity = 0
        }
        else {
            shiftb.setImage(UIImage(named: "shiftUp"), for: UIControlState.normal)
            deleteButton.setImage(UIImage(named: "deleteUp"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "lang"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enter"), for: UIControlState.normal)
        }
        // make tag to 1: it means we initialized main layer
        shiftViewLandscape.tag = 1
        shiftViewLandscape.isMultipleTouchEnabled = false
        // END OF ALEFBA LAYER
        
    }
    
    /************************************
    *                                   *
    *   Initial Number layer            *
    *                                   *
     
    ************************************/
    func initNumber(){
        
        // TODO: background should be checked here
        numberViewPortrait.backgroundColor = viewBackground
        
        // setup tap detection for background view
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        numberViewPortrait.addGestureRecognizer(tap)
        
        gapVertical = 10
        gapHorizontal = 6
        marginTop = 6
        marginRight = 4
        
        // calculate values that need to put the buttons on the layer based different UIScreens sizes 
        // in this layer we have only 10 buttons
        alefbaButtonWidth = (keyboardWidth - ((9 * gapHorizontal) + (2 * marginRight))) / 10
        alefbaButtonHeight = (keyboardHeight - ((2 * marginTop) + (3 * gapVertical))) / 4
        
        /*****************************************
         *                                        *
         *   initial first Numbers row            *
         *                                        *
         *****************************************/
        
        for i in 0...9
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)),
                           y: marginTop ,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            let b: UIButton = createButton(rect: r, char: alphabets[2][0][i].value)

            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            numberViewPortrait.addSubview(b)
            
        }
        /*****************************************
         *                                        *
         *   initial second Numbers row           *
         *                                        *
         *****************************************/
        for i in 0...9
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + gapVertical + alefbaButtonHeight,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[2][1][i].value)

            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            numberViewPortrait.addSubview(b)
        }
        
        /*****************************************
         *                                        *
         *   initial third Numbers row            *
         *                                        *
         *****************************************/

        let y = (2 * (alefbaButtonHeight + gapVertical)) + marginTop
        for i in 0...7
        {
            let r = CGRect( x:marginRight + (CGFloat(i) * (gapHorizontal + alefbaButtonWidth)),
                        y: y,
                        width: alefbaButtonWidth,
                        height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[2][2][i].value)

            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            numberViewPortrait.addSubview(b)
        }
        
        // initial delete button
        var r = CGRect( x: keyboardWidth - (marginRight + gapHorizontal + (2 * alefbaButtonWidth)),
                    y: y,
                    width: gapHorizontal + (2 * alefbaButtonWidth) ,
                    height: alefbaButtonHeight)
        let deleteButton = createUtilButton(rect: r, withTarget: false)
        deleteButton.tag = 3
        deleteButton.addTarget(self, action: #selector(self.utilTouched), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUpOutside), for: .touchUpOutside)
        numberViewPortrait.addSubview(deleteButton)
        
        /*****************************************
         *                                        *
         *   initial fourth alfabet row           *
         *                                        *
         *****************************************/
        // initial 123 button
        r = CGRect( x: marginRight,
                    y: keyboardHeight - (alefbaButtonHeight + marginTop),
                    width: alefbaButtonWidth * 1.25 ,
                    height: alefbaButtonHeight)
        let numberButton = createUtilButton(rect: r, withTarget: true)
        numberButton.setTitle("الفبا", for: UIControlState())
        numberButton.tag = 2
        numberViewPortrait.addSubview(numberButton)
        
        
        // Initial next button layer
        r = CGRect(x: marginRight + numberButton.frame.width + gapHorizontal ,
                   y: numberButton.frame.minY,
                   width: numberButton.frame.width ,
                   height: alefbaButtonHeight)
        let nextKeyboardButton = createUtilButton(rect: r, withTarget: true)
        nextKeyboardButton.tag = 99
        numberViewPortrait.addSubview(nextKeyboardButton)
        
        // initial left  button
        r = CGRect( x: nextKeyboardButton.frame.maxX + gapHorizontal,
                    y: numberButton.layer.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)
        
        let leftButton: UIButton = createButton(rect: r, char: alphabets[2][3][0].value)

        leftButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        numberViewPortrait.addSubview(leftButton)
        
        // initial Space button
        r = CGRect( x: leftButton.frame.maxX + gapHorizontal,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth * 3.5 ,
                    height: alefbaButtonHeight)
        let spaceButton=createUtilButton(rect: r, withTarget: false)
        spaceButton.setTitle("فاصله", for: UIControlState())
        spaceButton.tag = 32
        spaceButton.backgroundColor = buttonBackground
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        numberViewPortrait.addSubview(spaceButton)
        
        // initial Right button
        r = CGRect( x: spaceButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight  )
        let rightButton: UIButton = createButton(rect: r, char: alphabets[2][3][1].value)

        rightButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        numberViewPortrait.addSubview(rightButton)
        
        // add Enter button
        let w = keyboardWidth - ((8 * alefbaButtonWidth) + (2 * marginRight) + (5 * gapHorizontal))
        r = CGRect( x: keyboardWidth - (w + marginRight) ,
                                          y: numberButton.frame.minY,
                                          width: w ,
                                          height: alefbaButtonHeight)
        
        let EnterButton = createUtilButton(rect: r, withTarget: true)
        EnterButton.tag = 13
        numberViewPortrait.addSubview(EnterButton)
        
        // change icons to white color if apperiance is dark
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            deleteButton.setImage(UIImage(named: "deleteW"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "langW"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enterW"), for: UIControlState.normal)
            
            deleteButton.layer.shadowOpacity = 0
            nextKeyboardButton.layer.shadowOpacity = 0
            EnterButton.layer.shadowOpacity = 0
            numberButton.layer.shadowOpacity = 0
        }
        else {
            deleteButton.setImage(UIImage(named: "deleteUp"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "lang"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enter"), for: UIControlState.normal)
        }
        
        // make tag to 1: it means we initialized main layer
        numberViewPortrait.tag = 1
        numberViewPortrait.isMultipleTouchEnabled = false
        // END OF ALEFBA LAYER
        
    }
    
    
    // initail Number in Landscape layout
    func initNumberLandscape(){
        // TODO: background should be checked here
        numberViewLandscape.backgroundColor = viewBackground
        
        // setup tap detection for background view
        let tap = UITapGestureRecognizer(target: self, action: #selector(getCharacterFromNearestButton(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        numberViewLandscape.addGestureRecognizer(tap)
        
        gapVertical = 5
        gapHorizontal = 5.5
        marginTop = 4
        marginRight = 5
        
        // calculate values that need to put the buttons on the layer based different UIScreens sizes
        // in this layer we have only 10 buttons
        alefbaButtonWidth = (keyboardWidthLandscape - ((9 * gapHorizontal) + (2 * marginRight))) / 10
        alefbaButtonHeight = (keyboardHeightLandscape - ((2 * marginTop) + (3 * gapVertical))) / 4
        
        /*****************************************
         *                                        *
         *   initial first Numbers row            *
         *                                        *
         *****************************************/
        
        for i in 0...9
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)),
                           y: marginTop ,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            let b: UIButton = createButton(rect: r, char: alphabets[2][0][i].value)

            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            numberViewLandscape.addSubview(b)
            
        }
        /*****************************************
         *                                        *
         *   initial second Numbers row           *
         *                                        *
         *****************************************/
        for i in 0...9
        {
            let r = CGRect(x: marginRight + (CGFloat(i) * (alefbaButtonWidth + gapHorizontal)) ,
                           y: marginTop + gapVertical + alefbaButtonHeight,
                           width: alefbaButtonWidth,
                           height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[2][1][i].value)

            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            numberViewLandscape.addSubview(b)
        }
        
        /*****************************************
         *                                        *
         *   initial third Numbers row            *
         *                                        *
         *****************************************/
        
        let y = (2 * (alefbaButtonHeight + gapVertical)) + marginTop
        for i in 0...7
        {
            let r = CGRect( x:marginRight + (alefbaButtonWidth / 4) + (CGFloat(i) * (gapHorizontal + alefbaButtonWidth)),
                            y: y,
                            width: alefbaButtonWidth,
                            height: alefbaButtonHeight)
            
            let b: UIButton = createButton(rect: r, char: alphabets[2][2][i].value)
            b.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
            b.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
            
            numberViewLandscape.addSubview(b)
        }
        
        // initial delete button
        var r = CGRect( x: keyboardWidthLandscape - (marginRight + gapHorizontal + (1.75 * alefbaButtonWidth)),
                        y: y,
                        width: gapHorizontal + (1.5 * alefbaButtonWidth) ,
                        height: alefbaButtonHeight)
        let deleteButton = createUtilButton(rect: r, withTarget: false)
        deleteButton.tag = 3
        deleteButton.addTarget(self, action: #selector(self.utilTouched), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchDown), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.deleteTouchUpOutside), for: .touchUpOutside)
        numberViewLandscape.addSubview(deleteButton)
        
        /*****************************************
         *                                        *
         *   initial fourth alfabet row           *
         *                                        *
         *****************************************/
        // initial 123 button
        r = CGRect( x: marginRight + gapHorizontal + (alefbaButtonWidth / 2),
                    y: keyboardHeightLandscape - (alefbaButtonHeight + marginTop),
                    width: alefbaButtonWidth,
                    height: alefbaButtonHeight)
        let numberButton = createUtilButton(rect: r, withTarget: true)
        numberButton.setTitle("الفبا", for: UIControlState())
        numberButton.tag = 2
        numberViewLandscape.addSubview(numberButton)
        
        
        // Initial next button layer
        let nextKeyboardButton: UIButton = UIButton(type: .custom)
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.layer.cornerRadius = 5
        nextKeyboardButton.backgroundColor = utilBackgroundColor
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.layer.frame = CGRect(x: numberButton.frame.maxX + gapHorizontal ,
                                                y: numberButton.frame.minY,
                                                width: alefbaButtonWidth ,
                                                height: alefbaButtonHeight)
        
        nextKeyboardButton.tag = 99
        nextKeyboardButton.layer.shadowColor = buttonShadowColor
        nextKeyboardButton.layer.shadowOpacity = 0.8
        nextKeyboardButton.layer.shadowRadius = 0.5
        nextKeyboardButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        nextKeyboardButton.layer.shadowPath = UIBezierPath(roundedRect: nextKeyboardButton.bounds, cornerRadius: 5).cgPath
        
        nextKeyboardButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        nextKeyboardButton.addTarget(self, action: #selector(self.utilTouchDown), for: .touchDown)
        nextKeyboardButton.addTarget(self, action: #selector(self.utilTouchUpOutside), for: .touchUpOutside)
        nextKeyboardButton.addTarget(self, action: #selector(playTop), for: .touchDown)
        numberViewLandscape.addSubview(nextKeyboardButton)
        
        // initial left  button
        r = CGRect( x: nextKeyboardButton.frame.maxX + gapHorizontal,
                    y: numberButton.layer.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight)
        
        let leftButton: UIButton = createButton(rect: r, char: alphabets[2][3][0].value)
        
        leftButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        numberViewLandscape.addSubview(leftButton)
        
        // initial Space button
        r = CGRect( x: leftButton.frame.maxX + gapHorizontal,
                    y: numberButton.frame.minY,
                    width: (alefbaButtonWidth * 3.5) + (2 * gapHorizontal),
                    height: alefbaButtonHeight)
        let spaceButton = createUtilButton(rect: r, withTarget: false)
        spaceButton.setTitle("فاصله", for: UIControlState())
        spaceButton.tag = 32
        spaceButton.backgroundColor = buttonBackground
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        numberViewLandscape.addSubview(spaceButton)
        
        // initial Right button
        r = CGRect( x: spaceButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth ,
                    height: alefbaButtonHeight  )
        let rightButton: UIButton = createButton(rect: r, char: alphabets[2][3][1].value)
        
        rightButton.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(self.makeButtonBigger(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(self.makeButtonNormal(_:)), for: .touchUpOutside)
        numberViewLandscape.addSubview(rightButton)
        
        // initial Enter Button
        r = CGRect( x: rightButton.frame.maxX + gapHorizontal ,
                    y: numberButton.frame.minY,
                    width: alefbaButtonWidth * 1.5 ,
                    height: alefbaButtonHeight)
        let EnterButton = createUtilButton(rect: r, withTarget: true)
        EnterButton.tag = 13
        numberViewLandscape.addSubview(EnterButton)
        
        // change icons to white color if apperiance is dark
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            deleteButton.setImage(UIImage(named: "deleteW"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "langW"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enterW"), for: UIControlState.normal)

            deleteButton.layer.shadowOpacity = 0
            nextKeyboardButton.layer.shadowOpacity = 0
            EnterButton.layer.shadowOpacity = 0
            numberButton.layer.shadowOpacity = 0
        }
        else {
            deleteButton.setImage(UIImage(named: "deleteUp"), for: UIControlState.normal)
            nextKeyboardButton.setImage(UIImage(named: "lang"), for: UIControlState.normal)
            EnterButton.setImage(UIImage(named: "enter"), for: UIControlState.normal)
        }
        
        // make tag to 1: it means we initialized main layer
        numberViewLandscape.tag = 1
        numberViewLandscape.isMultipleTouchEnabled = false
        // END OF ALEFBA LAYER
        
    }
    
    
    
    /********************************
    *                               *
    *   Buttons Events              *
    *                               *
    ********************************/
    
    /************************************
    *       DELETE FUNCTION             *
    ************************************/
    // delete touching
    func deleteTouchDown(sender: UIButton)
    {
        sender.backgroundColor = utilButtonTouchDownColor
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
            if (proxy.hasText && proxy.documentContextBeforeInput != nil)
                {
                timer = Timer.scheduledTimer(timeInterval: deleteTimer, target: self, selector: #selector(doDeleting), userInfo: nil, repeats: false)
                if soundID == 2
                {
                    // user activated tap sound
                    AudioServicesPlaySystemSound(tapSound)
                }
            }
        }
    }
    // set deleting boolean value to false with this event
    func deleteTouchUpOutside(_ sender: UIButton)
    {
        deleting = false
        deleteTimer = 0.3
        timer.invalidate()
    }
    
    /************************************
     *       UTIL  FUNCTION             *
     ************************************/
    func toChar(s:String, i:Int) -> Character
    {
        let arr = Array(s.characters)
        return arr[i]
    }
    func utilTouchUpOutside(sender: UIButton)
    {
        sender.backgroundColor = utilBackgroundColor
    }
    // util touched down
    func utilTouchDown(sender: UIButton)
    {
        sender.backgroundColor = utilButtonTouchDownColor

    }
    // utility touched
    // 0: default value for all buttons = nothing
    // 1: shift
    // 2: numbers
    // 3: delete
    // 13: Enter (cariage return)
    // 32: space
    // 99: advanceToNextInputMode
    // 8204: nim fasele (half space!)
    func utilTouched(sender: UIButton)
    {
        
        
        let proxy = textDocumentProxy as UITextDocumentProxy
        switch sender.tag {
        case 0:
            print("nothing happened")
            break
        case 1:
            shift = !shift
            sender.backgroundColor = utilBackgroundColor
            if shift
            {
                currentLayout = 1
                layerManager(layer: 1)
            }
            else
            {
                currentLayout = 0
                layerManager(layer: 0)
            }
            break
        case 2:
            shift = false
            sender.backgroundColor = utilBackgroundColor
            if currentLayout == 2    // it means already we are in Number Layer
            {
                currentLayout = 0   // so we shoulf change to Alefba layer
                layerManager(layer: currentLayout)
            }
            else
            {
                currentLayout = 2
                layerManager(layer: currentLayout)
            }
            break
        case 3:
            sender.backgroundColor = utilBackgroundColor
            // reset deleting parameters to default
            deleting = false
            deleteTimer = 0.5
            timer.invalidate()
            break
        case 13:
            proxy.insertText("\n")
            sender.backgroundColor = utilBackgroundColor
            if currentLayout == 2 || currentLayout == 1
            {
                currentLayout = 0
                layerManager(layer: 0)
            }
        case 32:
            proxy.insertText(" ")
            
            sender.backgroundColor = buttonBackground
            if currentLayout == 2
            {
                currentLayout = 0
                layerManager(layer: 0)
            }
            break
        case 99:
            self.advanceToNextInputMode()
            sender.backgroundColor = utilBackgroundColor
            break
        case 8204:
            proxy.insertText("\u{200C}")
            sender.backgroundColor = buttonBackground
            shift = false
            currentLayout = 0
            layerManager(layer: currentLayout)
            break
        default:
            break
        }
    }
    
    /************************************
     *       ALEFBA FUNCTION            *
     ************************************/
    // add character into textfield
    func buttonTouched(_ sender: UIButton)
    {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(sender.currentTitle!)
        makeButtonNormal(sender)
    }
    
    // a button in shift layer touched
    func shiftButtonTouched(_ sender: UIButton)
    {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(sender.currentTitle!)
        
        makeButtonNormal(sender)
        
        // return layout to main view
        shift = false
        currentLayout = 0
        layerManager(layer: currentLayout)
        
    }
    
    // special shift function for (){}[] «»
    func signButtonTouched(_ sender: UIButton)
    {
        let proxy = textDocumentProxy as UITextDocumentProxy
        let char = sender.currentTitle!
        switch char {
        case ")":
            proxy.insertText("(")
            break
        case "(":
            proxy.insertText(")")
            break
        case "{":
            proxy.insertText("}")
            break
        case "}":
            proxy.insertText("{")
            break
        case "[":
            proxy.insertText("]")
            break
        case "]":
            proxy.insertText("[")
            break
        case "«":
            proxy.insertText("»")
            break
        case "»":
            proxy.insertText("«")
            break
        default:
            print("invalid sign character")
        }
        makeButtonNormal(sender)

        // return layout to main view
        shift = false
        currentLayout = 0
        layerManager(layer: currentLayout)
        
    }
    
    func makeButtonBigger(_ sender: UIButton) {
        aButtonTouched = true
        let button = sender
        let ltb = button.frame
        lastTouchedButton = sender
        if ltb.width != ltb.height {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26.0)
        }
        button.titleLabel?.textColor = makeButtonBiggerTextColor
        button.layer.borderColor = buttonBorderColor
        button.layer.borderWidth = 1
        button.backgroundColor = makeButtonBiggerBackground
        button.frame = CGRect(x: ltb.minX ,y:ltb.minY - self.gapVertical, width: ltb.width, height: button.frame.height + self.gapVertical)
    }
    
    func makeButtonNormal(_ sender: UIButton) {
        let button = sender
        let ltb = button.frame
        button.frame = CGRect(x: ltb.minX ,
                              y:ltb.minY + self.gapVertical,
                              width: ltb.width,
                              height: button.frame.height - self.gapVertical)
        button.layer.borderWidth = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.backgroundColor = buttonBackground
        
        aButtonTouched = false
    }
    /************************************
     *       OTHER  FUNCTION            *
     ************************************/

    func getDistance(a1:CGFloat, b1:CGFloat, a2:CGFloat, b2:CGFloat) -> CGFloat
    {
        let deltaA:CGFloat = a1 - a2
        let deltaB:CGFloat = b1 - b2
        return CGFloat(sqrtf(Float((deltaA * deltaA)) + Float((deltaB * deltaB))))
    }
    // and the number of Layer: 0 = Main Layer , 1= Shift Layer, 2= numbers layer
    func layerManager(layer: Int)
    {
        print("func layerManager(layer: Int)")
        if UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        {
            switch layer {
            case 0:
                if mainViewPortrait.tag == 0
                {
                    initAlefba()
                }
                self.view = mainViewPortrait
                break
            case 1:
                if shiftViewPortrait.tag == 0
                {
                    initShift()
                }
                self.view = shiftViewPortrait
                break
            case 2:
                if numberViewPortrait.tag == 0
                {
                    initNumber()
                }
                self.view = numberViewPortrait
                break
            default:
                print("strange sitation in layer landscape \"mode\" manager")
                break
            }
        }
        else
        {
            switch layer {
            case 0:
                if mainViewLandscape.tag == 0
                {
                    initAlefbaLandscape()
                }
                self.view = mainViewLandscape
                break
            case 1:
                if shiftViewLandscape.tag == 0
                {
                    initShiftLandscape()
                }
                self.view = shiftViewLandscape
                break
            case 2:
                if numberViewLandscape.tag == 0
                {
                    initNumberLandscape()
                    
                }
                self.view = numberViewLandscape
                break
            default:
                print("strange sitation in layer manager")
                break
            }
        }
    }

    
    func createButton( rect: CGRect, char: Character = "x") -> UIButton
    {
        
        let btn: UIButton = UIButton(type: .custom)
        if char != "x" {
            btn.setTitle(String(char), for: UIControlState())
        }
        // I set Tag to -1 for detecting button when background touched!
        btn.tag = -1
        btn.sizeToFit()
        
        if #available(iOSApplicationExtension 10.0, *) {
            btn.titleLabel?.adjustsFontForContentSizeCategory = true
        } else {
            // fallback....
        }
        
        btn.backgroundColor = buttonBackground
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(textColorNormal, for: UIControlState())
        btn.setTitleColor(textColorHighlighted, for: UIControlState.highlighted)
        btn.layer.cornerRadius = 5
        btn.frame = rect
        btn.layer.shadowColor = buttonShadowColor
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 0.5
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btn.layer.shadowPath = UIBezierPath(roundedRect: btn.bounds, cornerRadius: 5).cgPath
        btn.isExclusiveTouch = true
        
        // set user default sound on tap
        switch soundID {
        case 0:
            // user selected mute, we don't need to do anything
            break
        case 1:
            // user vibration selceted
            btn.addTarget(self, action: #selector(playVib), for: .touchDown)
            break
        case 2:
            // user activated tap sound
            btn.addTarget(self, action: #selector(playTap), for: .touchDown)
            break
        default:
            print("invalid value happen in sound switch-case")
            break
        }
        return btn
    }
    
    // create buttons for utils buttons such Enter, space, delete....
    func createUtilButton(rect: CGRect, withTarget: Bool) -> UIButton
    {
        let b: UIButton = UIButton(type: .custom)
        b.sizeToFit()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(textColorNormal, for: UIControlState())
        b.layer.cornerRadius = 5
        b.layer.frame = rect
        b.backgroundColor = utilBackgroundColor
        b.layer.shadowColor = buttonShadowColor
        b.layer.shadowOpacity = 0.8
        b.layer.shadowRadius = 0.5
        b.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        b.isExclusiveTouch = true
        b.layer.shadowPath = UIBezierPath(roundedRect: b.bounds, cornerRadius: 5).cgPath
        if withTarget
        {
            b.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(self.utilTouchDown), for: .touchDown)
            b.addTarget(self, action: #selector(self.utilTouchUpOutside), for: .touchUpOutside)
        }
        // set user default sound on tap
        switch soundID {
        case 0:
            // user selected mute, we don't need to do anything
            break
        case 1:
            // user vibration selceted
            b.addTarget(self, action: #selector(playVib), for: .touchDown)
            break
        case 2:
            // user activated tap sound
            b.addTarget(self, action: #selector(playTop), for: .touchDown)
            break
        default:
            print("invalid value happen in sound switch-case")
            break
            
        }

        return b
    }
    func playTap()
    {
        AudioServicesPlaySystemSound(tapSound)
    }
    
    func playTop()  // :D
    {
        AudioServicesPlaySystemSound(topSound)
    }
    
    func playVib()  // :D
    {
        AudioServicesPlaySystemSound(vibSound)
    }
    
    func getCharacterFromNearestButton(_ sender: UITapGestureRecognizer)
    {
        if let v = sender.view
        {
            var distanceToClosestButton:CGFloat = 9999
            let touchLocation = sender.location(in: v)
            var button: UIButton = UIButton()
            for case let b as UIButton in v.subviews
            {
                let currentButtonDistance = getDistance(a1: b.frame.midX, b1: b.frame.midY, a2: touchLocation.x, b2: touchLocation.y)
                if currentButtonDistance < distanceToClosestButton
                {
                    button = b
                    distanceToClosestButton = currentButtonDistance
                }
            }
            
            // utility touched
            // 0: default value for all buttons = nothing
            // 1: shift
            // 2: numbers
            // 3: delete
            // 13: Enter (cariage return)
            // 32: space
            // 99: advanceToNextInputMode
            // 8204: nim fasele (half space!)
            switch button.tag {
            case -1:
                // set user default sound on tap
                switch soundID {
                case 0:
                    // user selected mute, we don't need to do anything
                    break
                case 1:
                    // user vibration selceted
                    playVib()
                    break
                case 2:
                    // user activated tap sound
                    playTap()
                    break
                default:
                    print("invalid value happen in sound switch-case")
                    break
                    
                }
                let proxy = textDocumentProxy as UITextDocumentProxy
                proxy.insertText(button.currentTitle!)
                button.backgroundColor = makeButtonBiggerBackground
                UIView.animate(withDuration: 0.4, animations: {
                    button.backgroundColor = self.buttonBackground
                })
                // check if we are in shift layer
                if currentLayout == 1
                {
                    // return layout to main view
                    shift = false
                    currentLayout = 0
                    layerManager(layer: currentLayout)
                }
                break
            case 1,2,3,13,32,99,8204:
                utilTouched(sender: button)
                break
            case 0:
                print("something strange in getCharacterFromNearestButton happened")
                return
            default:
                print("something strange in getCharacterFromNearestButton happened, in default case")
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
        
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if aButtonTouched
        {
            makeButtonNormal(lastTouchedButton)
        }
        
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)")
        layerManager(layer: currentLayout)

    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        print("override func viewWillAppear(_ animated: Bool)")
        super.viewWillAppear(animated)
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            viewBackground = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
            utilBackgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
            buttonBackground = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0)
            textColorNormal = UIColor.white
            textColorHighlighted = UIColor.lightGray
            makeButtonBiggerTextColor = UIColor.white
            makeButtonBiggerBackground = UIColor.gray
        }
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup colors
        
        
        // detect keyboardwidth and height
        var screenWidth: CGFloat = 0
        var screenHeight: CGFloat = 0
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        {
            screenHeight = UIScreen.main.bounds.size.width
            screenWidth = UIScreen.main.bounds.size.height
        }
        else
        {
            screenWidth = UIScreen.main.bounds.size.width
            screenHeight = UIScreen.main.bounds.size.height
            
        }
        
        // get user Sound settings
        let prefs = UserDefaults(suiteName: "group.me.alirezak.gpkeys")
        soundID = (prefs?.integer(forKey: "sound"))!
        
        // always keyboard width in portrait is equal to screen width
        keyboardWidth = screenWidth
        
        // and keyboard width in Landscape is equal to screen height
        keyboardWidthLandscape = screenHeight
        
        switch screenWidth {
        case CGFloat(320):  // iphone 5/5s
            keyboardHeight = 216.0
            keyboardHeightLandscape = 162.0
            break
        case CGFloat(375):  // iphone 6/6s
            keyboardHeight = 216.0
            keyboardHeightLandscape = 162.0
            break
        case CGFloat(414): // iphone 6+/6s+
            keyboardHeight = 226
            keyboardHeightLandscape = 162
            break
        default:
            // TODO: I should impliment keyboard for iPads too!...
            print("someting else detected!", UIScreen.main.bounds.size)
            break
        }
        currentLayout = 0
        layerManager(layer: currentLayout)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        print("override func textDidChange(_ textInput: UITextInput?)")
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
    
}
