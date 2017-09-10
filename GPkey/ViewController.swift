//
//  ViewController.swift
//  GPkey
//
//  Created by sohrab on 19/09/16.
//  Copyright © 2016 ark. All rights reserved.
//


import UIKit
import AudioToolbox
import StoreKit

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

    let prefs = UserDefaults(suiteName: "group.me.alirezak.gpkeys")
    
    // store variables
    let productIdentifiers = Set(["me.alirezak.gpkeyboard.emojiplusfa"])
    var product: SKProduct?
    var productsArray:[SKProduct]?
    /*****************************************
     *                                       *
     *       App main screen function        *
     *                                       *
     ****************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        
        // define default rect for all views
        defaultSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height) / 6)
        
        
        initSmiliesLayer()
        let emojiPlus = prefs?.bool(forKey: "emojiPlus")
        if emojiPlus != true {
            buyButton?.isEnabled = false
            requestProductData()
        }
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
        l.text = "Here we tried to fit all popular emojis that you don't need to buy the full program. Of course, if you buy it, we appreciate that and we have more energy to develop Gachpazh in the future version. To change an emoji, you need to just tap on it and with standard emoji keyboard choose your desired emoji."
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor.darkGray
        l.numberOfLines = 0
        l.sizeToFit()
        l.frame = CGRect(x: 10, y: defaultSize.height + (-1.2 * buttonWidth), width: defaultSize.width - 20, height: 130)
        self.view.addSubview(l)
        
        
        
        // initial buttons 2x11
        let firstHeader = UILabel()
        firstHeader.text = "Emoji in character Layer"
        firstHeader.textColor = UIColor.darkGray
        firstHeader.font = UIFont.boldSystemFont(ofSize: 14)
        firstHeader.sizeToFit()
        firstHeader.frame = CGRect(x: 10, y: defaultSize.height + 3 * buttonWidth , width: 200, height: 30)
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
            b.frame = CGRect(x: 4 + (CGFloat(i) * (buttonWidth + 4)), y:  defaultSize.height + (4 * buttonWidth) , width: buttonWidth, height: buttonWidth)
            b.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchDown)
            self.view.addSubview(b)
            emojiButtons.append(b)
        }
        
        let secondHeader = UILabel()
        secondHeader.text = "Emoji in shift Layer"
        secondHeader.textColor = UIColor.darkGray
        secondHeader.font = UIFont.boldSystemFont(ofSize: 14)
        secondHeader.sizeToFit()
        secondHeader.frame = CGRect(x: 10, y:  defaultSize.height + (5 * buttonWidth) , width: 200, height: 30)
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
            b.frame = CGRect(x: 4 + (CGFloat(i) * (buttonWidth + 4)), y: (6 * buttonWidth) +  defaultSize.height, width: buttonWidth, height: buttonWidth)
            b.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
            self.view.addSubview(b)
            emojiButtons.append(b)
        }
        
        let thirdHeader = UILabel()
        thirdHeader.text = "Emoji in number Layer"
        thirdHeader.textColor = UIColor.darkGray
        thirdHeader.font = UIFont.boldSystemFont(ofSize: 14)
        thirdHeader.sizeToFit()
        thirdHeader.frame = CGRect(x: 10, y:  defaultSize.height + (7 * buttonWidth) , width: 200, height: 30)
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
            b.frame = CGRect(x: 4 + (CGFloat(i) * (buttonWidth + 4)), y: (8 * buttonWidth) +  defaultSize.height, width: buttonWidth, height: buttonWidth)
            b.addTarget(self, action: #selector(emojiSelected(_:)), for: .touchUpInside)
            self.view.addSubview(b)
            emojiButtons.append(b)
        }
        
        // _____________ Setup buy objects ____________
        // check if user already bought emojiPlus
        let emojiPlus = prefs?.bool(forKey: "emojiPlus")
        if emojiPlus != true
        {
            // buy button
            buyButton = UIButton()
            buyButton?.setTitle("Buy", for: .normal)
            buyButton?.setImage(UIImage(named: "buy"), for: .normal)
            buyButton?.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
            buyButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            buyButton?.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.25)
            buyButton?.setTitleColor(UIColor.black, for: UIControlState.normal)
            buyButton?.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            buyButton?.layer.borderWidth = 2
            buyButton?.layer.cornerRadius = 5
            buyButton?.layer.borderColor = UIColor(red:0.66, green:0.28, blue:0.28, alpha:1.0).cgColor
            buyButton?.isExclusiveTouch = true
            buyButton?.frame = CGRect(x: (defaultSize.width / 2) + 10, y: defaultSize.height + (10 * buttonWidth), width: 150, height: 30)
            buyButton?.addTarget(self, action: #selector(buyItem), for: .touchUpInside)
            self.view.addSubview(buyButton!)
            
            // restore button
            restoreButton = UIButton()
            restoreButton?.setTitle("restore", for: .normal)
            restoreButton?.setImage(UIImage(named: "restore"), for: .normal)
            restoreButton?.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.25)
            restoreButton?.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
            restoreButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            restoreButton?.setTitleColor(UIColor.black, for: UIControlState.normal)
            restoreButton?.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            restoreButton?.layer.borderWidth = 2
            restoreButton?.layer.cornerRadius = 5
            restoreButton?.layer.borderColor = UIColor(red:0.66, green:0.28, blue:0.28, alpha:1.0).cgColor
            restoreButton?.isExclusiveTouch = true
            restoreButton?.frame = CGRect(x: (defaultSize.width / 2)  - 160, y: defaultSize.height + (10 * buttonWidth), width: 150, height: 30)
            restoreButton?.addTarget(self, action: #selector(restore), for: .touchUpInside)
            self.view.addSubview(restoreButton!)
            
            // add buy description
            buyLabel = UILabel()
            buyLabel?.text = "To change the emojies, you need to buy the full app."
            buyLabel?.font = UIFont.systemFont(ofSize: 14)
            buyLabel?.textColor = UIColor.darkGray
            buyLabel?.numberOfLines = 0
            buyLabel?.sizeToFit()
            buyLabel?.frame = CGRect(x: 10, y: defaultSize.height + (12 * buttonWidth), width: defaultSize.width - 20 , height: 50)
            self.view.addSubview(buyLabel!)
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
        
        let emojiPlus = prefs?.bool(forKey: "emojiPlus")
        if emojiPlus == true // app purchase should check here
        {
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
        else
        {
            let alert = UIAlertController(title: "trial version", message: "To change the emojies, you need to buy full version", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Maybe later", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Buy", style: .default, handler:buyEmojis))
            self.present(alert, animated: true, completion: nil)
            emojiText.text = ""
        }
    }
    
    // buy package from appstore
    func buyEmojis(alert: UIAlertAction!)
    {
        buyItem()
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
    func hideBuyObjects()
    {
        buyButton?.removeFromSuperview()
        restoreButton?.removeFromSuperview()
        buyLabel?.removeFromSuperview()
        
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


// MARK: - Store extension
extension ViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    func requestProductData()
    {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate=self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        productsArray = [SKProduct]()
        if (products.count != 0) {
            for p in products
            {
                productsArray?.append(p)
            }
            buyButton?.isEnabled = true
        }
    }
    
    func buyItem()
    {
        guard let p = productsArray?.first else { return}
        let payment = SKPayment(product: p as SKProduct)
        SKPaymentQueue.default().add(payment)
        buyButton?.isEnabled = false // disable buttun until response return from apple server
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions
        {
            switch transaction.transactionState {
            case .purchased:
                prefs?.set(true, forKey: "emojiPlus")
                prefs?.synchronize()
                hideBuyObjects()
                SKPaymentQueue.default().finishTransaction(transaction)
                let alert = UIAlertController(title: "Purchase finished", message: "Purchase successfully finished. Now you can change the emojies", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
            case .failed:
                if let transactionError = transaction.error as NSError? {
                    if transactionError.code != SKError.paymentCancelled.rawValue {
                        let alert = UIAlertController(title: "Error in purchase, please try again", message:transaction.error?.localizedDescription, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
                    }
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                buyButton?.isEnabled = true

                
            default:
                buyButton?.isEnabled = true
            }
        }
    }
    
    func restore()
    {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue)
    {
        for transaction:SKPaymentTransaction in queue.transactions {
            if transaction.payment.productIdentifier == productIdentifiers.first
            {
                prefs?.set(true, forKey: "emojiPlus")
                prefs?.synchronize()
                hideBuyObjects()
                let alert = UIAlertController(title: "Restore purchase", message: "Your previous purchase successfully restored.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
        }
        let alert = UIAlertController(title: "Restore purchase", message: "There is no previous purchase", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}




