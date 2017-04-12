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
    
    var tapSound: SystemSoundID = 1104
    let topSound: SystemSoundID = 1105
    let vibSound: SystemSoundID = 1520
    var soundID: Int = 0
    /****************************
     *   define alphabet value   *
     ****************************/
    struct Alefba {
        let Seda: String
        let value: String
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
    var keyboardWidth: CGFloat = 0    // should be calculated according to UIScreen
    var keyboardHeight: CGFloat = 0   // should be calculated according to UIScreen
    var keyboardHeightLandscape:CGFloat = 0 // should be calculated according to UIScreen
    var keyboardWidthLandscape:CGFloat = 0  // should be calculated according to UIScreen
    var gapHorizontal: CGFloat = 2.5    // in iPad screens should be multiply by 2
    var gapVertical: CGFloat = 4        // in iPad Screen should be multiply by 2
    var alefbaButtonWidth: CGFloat = 0  // should be calculated according to UIScreen
    var alefbaButtonHeight: CGFloat = 0 // should be calculated according to UIScreen
    var marginRight:CGFloat = 1.75  // in iPad screen it should be multiply by 2
    var marginLeft:CGFloat = 1.75  // in iPad screen it should be multiply by 2
    var marginBottom:CGFloat = 1.75  // in iPad screen it should be multiply by 2
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
    var mainViewPortrait: UIView = UIView()
    let shiftViewPortrait: UIView = UIView()
    let numberViewPortrait: UIView = UIView()
    var mainViewLandscape: UIView = UIView()
    let shiftViewLandscape:UIView = UIView()
    let numberViewLandscape:UIView = UIView()
    
    // show alphabet above the touched button
    var shower:UILabel = UILabel()
    var lastTouchedButton: UIButton!
    
    /*******  user pref variables   ********/
    var emojiState = 0
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
        // TODO: what does is it?!
        tap.requiresExclusiveTouchType = false
        mainViewPortrait.addGestureRecognizer(tap)
        
        // TODO: UIscreen should check here and assign respectively
//        gapVertical = 6
//        gapHorizontal = 4
//        marginRight = 1.75  // in iPad screen it should be multiply by 2
//        marginTop = 1.5     // if emoji is off it should increase
        gapVertical = 6
        gapHorizontal = 5
        marginTop = 3
        marginRight = 1.5
        
        // calculate values that need to put the buttons on the layer based different UIScreens sizes
        alefbaButtonWidth = (keyboardWidth - (10 * gapHorizontal) + marginLeft + marginRight) / 11
        // TODO: how should we calculate it?
        alefbaButtonHeight = alefbaButtonWidth * 1.4
        
        // read user setting if smilies are ON
        // calculate the heigh of buttons
        var isSmileOn:CGFloat = 0
        let prefs = UserDefaults(suiteName: "group.me.alirezak.gpkeys")
        emojiState = prefs?.integer(forKey: "emojiState") ?? 0
        if emojiState == 1
        {
//            alefbaButtonHeight = (keyboardHeight - ((4 * gapVertical) + (2 * marginTop) + alefbaButtonWidth)) / 4
            isSmileOn = 1
        }
        else
        {
            // TODO: which value should be set?
            marginTop = 20
        }
        
        var alefbaButtons = [[GPButton]]()
        
        
        /*****************************************
         *                                        *
         *   initial Smily row                    *
         *                                        *
         *****************************************/
        // check user setting if he want to use smily. Also

        if emojiState == 1
        {
            var rowButtons = [GPButton]()
            for i in 0...10
            {
                let btn = GPButton(with: .EMOJI)
                btn.label?.text = smile[i]
                rowButtons.append(btn)
                print(smile[i])
                btn.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
                mainViewPortrait.addSubview(btn)

            }
            alefbaButtons.append(rowButtons)
        }
        
        /*****************************************
         *                                        *
         *   initial all alfabet button           *
         *                                        *
         *****************************************/
        
        for i in 0..<alphabets[0].count
        {
            var rowButtons = [GPButton]()
            for j in 0..<alphabets[0][i].count
            {
                var btn = GPButton(with: .CHAR)
                
                btn.label?.text = alphabets[0][i][j].value
                rowButtons.append(btn)
                btn.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
                mainViewPortrait.addSubview(btn)
            }
            alefbaButtons.append(rowButtons)
        }
        // add all util function

        var shiftButton = GPButton(with: .SHIFT)
        shiftButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        shiftButton.label?.text = ".؟!"
        alefbaButtons[emojiState + 2].insert(shiftButton, at: 0)
        mainViewPortrait.addSubview(shiftButton)
        
        var deleteButton = GPButton(with: .DELETE)
        deleteButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        deleteButton.label?.text = "dele"
        alefbaButtons[emojiState + 2].insert(deleteButton, at: alefbaButtons[emojiState + 2].count)
        mainViewPortrait.addSubview(deleteButton)
        
        var numberButton = GPButton(with: .NUMBER)
        numberButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        numberButton.label?.text = "۱۲۳"
        alefbaButtons[emojiState + 3].insert(numberButton, at: 0)
        mainViewPortrait.addSubview(numberButton)
        
        var globeButton = GPButton(with: .GLOBE)
        globeButton.addTarget(self, action: #selector(self.advanceToNextInputMode), for: .touchDown)
        //globeButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        globeButton.label?.text = "globe"
        alefbaButtons[emojiState + 3].insert(globeButton, at: 1)
        mainViewPortrait.addSubview(globeButton)
        
        var spaceButton = GPButton(with: .SPACE)
        spaceButton.label?.text = "فاصله"
        spaceButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        alefbaButtons[emojiState + 3].insert(spaceButton, at: 3)
        mainViewPortrait.addSubview(spaceButton)
        
        var enterButton = GPButton(with: .ENTER)
        enterButton.addTarget(self, action: #selector(self.utilTouched(sender:)), for: .touchUpInside)
        enterButton.label?.text = "enter"
        alefbaButtons[emojiState + 3].insert(enterButton, at: 5)
        mainViewPortrait.addSubview(enterButton)
        
        setConstraints(buttons: alefbaButtons, kbLayout: mainViewPortrait, VSpace: 0, HSpace: 0, MarginTop: marginTop, MarginRight: marginRight, MarginBottom: marginBottom, leftSpace: marginLeft)
        
        self.view.updateConstraints()
        // make tag to 1: it means we initialized main layer
        mainViewPortrait.tag = 1
        mainViewPortrait.isMultipleTouchEnabled = false
        // END OF ALEFBA LAYER
        
    }
    
    func setConstraints(buttons: [[GPButton]], kbLayout: UIView, VSpace: CGFloat, HSpace: CGFloat,
                        topSpace:CGFloat, rightSpace: CGFloat, bottomSpace: CGFloat, leftSpace: CGFloat)
    {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: buttons[emojiState][0], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1, constant: alefbaButtonWidth))
        constraints.append(NSLayoutConstraint(item: buttons[emojiState][0], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState][0], attribute: .width, multiplier: 1, constant: alefbaButtonHeight))
        //buttons[emojiState][0].widthAnchor.constraint(equalToConstant: alefbaButtonWidth).isActive = true
        //buttons[emojiState][0].heightAnchor.constraint(equalToConstant: alefbaButtonHeight).isActive = true
        
        // TODO: we need following variables: VSpace, HSpace, TopMarign, BottomMargin, LeftMargin=rightMargin
        for i in 0..<buttons.count
        {
            for j in 0..<buttons[i].count
            {
                
                
                // it is corner top left
                if i==0 && j==0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .top, relatedBy: .equal, toItem: kbLayout, attribute: .top, multiplier: 1, constant: topSpace))
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .left, relatedBy: .equal, toItem: kbLayout, attribute: .left, multiplier: 1, constant: leftSpace))
                }
                // it is corner left bottom
                if i == buttons.count-1 && j == 0
                {
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .bottom, relatedBy: .equal, toItem: kbLayout, attribute: .bottom, multiplier: 1, constant: bottomSpace))
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .left, relatedBy: .equal, toItem: kbLayout, attribute: .left, multiplier: 1, constant: rightSpace))
                    
                }
                // corner top right
                if i==0 && j == buttons[i].count-1
                {

                    buttons[i][j].topAnchor.constraint(equalTo: kbLayout.topAnchor, constant: MarginTop).isActive = true
                    buttons[i][j].rightAnchor.constraint(equalTo: kbLayout.rightAnchor, constant: MarginRight * -1).isActive = true
                }
                // corner bottom right
                if i == buttons.count-1 && j == buttons[i].count-1
                {
                    buttons[i][j].bottomAnchor.constraint(equalTo: kbLayout.bottomAnchor, constant: 2 * -1).isActive = true
                    buttons[i][j].rightAnchor.constraint(equalTo: kbLayout.rightAnchor, constant: marginRight * -1).isActive = true
                }
                // all keys in right side
                if j == buttons[i].count-1
                {
                    buttons[i][j].rightAnchor.constraint(equalTo: kbLayout.rightAnchor, constant: MarginRight * -1).isActive = true
                }
                // all keys in left side
                if j==0 && i != 0
                {
                    buttons[i][j].topAnchor.constraint(equalTo: buttons[i-1][j].bottomAnchor, constant: 8).isActive = true
                    buttons[i][j].leftAnchor.constraint(equalTo: kbLayout.leftAnchor, constant: MarginRight).isActive = true
                }
                if j > 0
                {
                    buttons[i][j].topAnchor.constraint(equalTo: buttons[i][j-1].topAnchor).isActive = true
                    buttons[i][j].leftAnchor.constraint(equalTo: buttons[i][j-1].rightAnchor, constant: 4).isActive = true
                }
                
                // width & height constraint:
                buttons[i][j].heightAnchor.constraint(equalTo: buttons[1][0].heightAnchor).isActive = true
            
                let type = buttons[i][j].type!
                switch type
                {
                case .CHAR:
                    buttons[i][j].widthAnchor.constraint(equalTo: buttons[1][0].widthAnchor).isActive = true
                    break
                case .EMOJI:
                    buttons[i][j].widthAnchor.constraint(equalTo: buttons[1][0].widthAnchor).isActive = true
                    buttons[i][j].heightAnchor.constraint(equalTo: buttons[1][0].widthAnchor).isActive = true
                    break
                case .SHIFT, .DELETE:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: buttons[1][0], attribute: .width, multiplier: 1.5, constant: 0))
                    break
                case .ENTER:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[1][0], attribute: .width, multiplier: 1.75, constant: 0))
                    break
                case .SPACE:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .greaterThanOrEqual, toItem: buttons[1][0], attribute: .width, multiplier: 4, constant: 0))
                    break
                case .GLOBE, .NUMBER:
                    constraints.append(NSLayoutConstraint(item: buttons[i][j], attribute: .width, relatedBy: .equal, toItem: buttons[1][0], attribute: .width, multiplier: 1.25, constant: 0))
                    break
                default:
                    break;
                }
            }
        }

        // set the width of shift and delete button to equal width
        constraints.append(NSLayoutConstraint(item: buttons[emojiState + 2][0], attribute: .width, relatedBy: .equal, toItem: buttons[emojiState + 2][9], attribute: .width, multiplier: 1, constant: 0))
        
        
        kbLayout.addConstraints(constraints)
    }
    
    
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
    func utilTouched(sender: GPButton)
    {
        
        print("happedned")
        let proxy = textDocumentProxy as UITextDocumentProxy
        let type = sender.type!
        switch type
        {
        case .SPACE:
            proxy.insertText(" ")
            
            sender.backgroundColor = buttonBackground
            if currentLayout == 2
            {
                currentLayout = 0
                layerManager(layer: 0)
            }
            break
        case .GLOBE:
            self.advanceToNextInputMode()
            sender.backgroundColor = utilBackgroundColor
            break
        case .SHIFT:
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
        case .NUMBER:
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
        case .ENTER:
            sender.backgroundColor = utilBackgroundColor
            // reset deleting parameters to default
            deleting = false
            deleteTimer = 0.5
            timer.invalidate()
            break
        case .DELETE:
            proxy.insertText("\n")
            sender.backgroundColor = utilBackgroundColor
            if currentLayout == 2 || currentLayout == 1
            {
                currentLayout = 0
                layerManager(layer: 0)
            }
        case .HALBSPACE:
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
    }
    
    // a button in shift layer touched
    func shiftButtonTouched(_ sender: UIButton)
    {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(sender.currentTitle!)
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

        // return layout to main view
        shift = false
        currentLayout = 0
        layerManager(layer: currentLayout)
        
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
        if UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        {
            switch layer {
            case 0:
                mainViewPortrait = UIView()
                mainViewPortrait.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(mainViewPortrait)
                mainViewPortrait.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                mainViewPortrait.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                mainViewPortrait.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                mainViewPortrait.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                initAlefba()

                break
            case 1:
                if shiftViewPortrait.tag == 0
                {
                    //initShift()
                }
                self.view = shiftViewPortrait
                break
            case 2:
                if numberViewPortrait.tag == 0
                {
                    //initNumber()
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
                    //initAlefbaLandscape()
                }
                self.view = mainViewLandscape
                break
            case 1:
                if shiftViewLandscape.tag == 0
                {
                    //initShiftLandscape()
                }
                self.view = shiftViewLandscape
                break
            case 2:
                if numberViewLandscape.tag == 0
                {
                    //initNumberLandscape()
                    
                }
                self.view = numberViewLandscape
                break
            default:
                print("strange sitation in layer manager")
                break
            }
        }
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
            var button: GPButton = GPButton()
            for case let b as GPButton in v.subviews
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
                proxy.insertText((button.label?.text)!)
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
        
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
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
        print("screen bounds",UIScreen.main.bounds.size)
        
        switch screenWidth {
        case CGFloat(320):  // iphone 5/5s
            keyboardHeight = 216.0
            keyboardHeightLandscape = 162.0
            break
        case CGFloat(375):  // iphone 6/6s/7
            keyboardHeight = 216.0
            keyboardHeightLandscape = 162.0
            break
        case CGFloat(414): // iphone 6+/6s+/7+
            keyboardHeight = 226
            keyboardHeightLandscape = 162
            break
        default:
            // TODO: I should impliment keyboard for iPads too!...
            print("someting else detected!", UIScreen.main.bounds.size)
            keyboardHeight = 216.0
            keyboardHeightLandscape = 162.0
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
