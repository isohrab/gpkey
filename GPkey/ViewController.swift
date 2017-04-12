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
    
    @IBOutlet weak var emojiSW: UISwitch!
    var tapSound: SystemSoundID = 1104
    var defaultSize: CGSize!
    
    // objects for smilies layer
    let defaultEmojies =  "\u{1F600}\u{1F601}\u{1F602}\u{1F60E}\u{1F60D}\u{1F618}\u{0263A}\u{1F61C}\u{1F914}\u{1F339}\u{02764}\u{1F610}\u{1F61E}\u{1F62D}\u{1F633}\u{1F631}\u{1F620}\u{1F621}\u{1F382}\u{1F381}\u{1F38A}\u{1F494}"
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
        
        // initial emojis On/Off button
        if let b = prefs?.integer(forKey: "emojiState")
        {
            if b != 0
            {
                emojiOnOff = 1
                prefs?.set(emojiOnOff, forKey: "emojiState")
                prefs?.synchronize()
                emojiSW.setOn(true, animated: false)
            }
            
        }
        else
        {
            emojiOnOff = 0
            prefs?.set(emojiOnOff, forKey: "emojiState")
            prefs?.synchronize()
            emojiSW.setOn(false, animated: false)
        }
        // setup emoji buttons and description label
        let buttonWidth:CGFloat = (defaultSize.width - (12 * 4)) / 11
        
        // initial buttons 2x11
        let firstHeader = UILabel()
        firstHeader.text = "شکلک های لایه اصلی"
        firstHeader.textColor = UIColor.darkGray
        firstHeader.font = UIFont.boldSystemFont(ofSize: 14)
        firstHeader.sizeToFit()
        firstHeader.frame = CGRect(x: defaultSize.width - 210, y: defaultSize.height + buttonWidth , width: 200, height: 30)
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
                b.setTitle(String(defaultEmojies.charAt(i)), for: .normal)
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
        secondHeader.text = "شکلک های لایه شیفت"
        secondHeader.textColor = UIColor.darkGray
        secondHeader.font = UIFont.boldSystemFont(ofSize: 14)
        secondHeader.sizeToFit()
        secondHeader.frame = CGRect(x: defaultSize.width - 210, y:  defaultSize.height + (3 * buttonWidth) , width: 200, height: 30)
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
                b.setTitle(String(defaultEmojies.charAt(i + 11)), for: .normal)
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
        
        // add instruction label on layer
        let l = UILabel()
        l.text = "برای تغییر هر شکلک روی آن تپ کنید و از کیبورد استاندارد اِموجی ها، شکلک دلخواه خود را انتخاب نمایید"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor.darkGray
        l.numberOfLines = 0
        l.sizeToFit()
        l.frame = CGRect(x: 10, y: defaultSize.height + (5 * buttonWidth), width: defaultSize.width - 20, height: 50)
        self.view.addSubview(l)
        
        // _____________ Setup buy objects ____________
        // check if user already bought emojiPlus
        let emojiPlus = prefs?.bool(forKey: "emojiPlus")
        if emojiPlus != true
        {
            // buy button
            buyButton = UIButton()
            buyButton?.setTitle("خرید نسخه کامل", for: .normal)
            buyButton?.setImage(UIImage(named: "buy"), for: .normal)
            buyButton?.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
            buyButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            buyButton?.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.25)
            buyButton?.setTitleColor(UIColor.black, for: UIControlState.normal)
            buyButton?.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            buyButton?.layer.borderWidth = 2
            buyButton?.layer.cornerRadius = 5
            buyButton?.layer.borderColor = UIColor(red:0.66, green:0.28, blue:0.28, alpha:1.0).cgColor
            buyButton?.isExclusiveTouch = true
            buyButton?.frame = CGRect(x: (defaultSize.width / 2) + 10, y: defaultSize.height + (8 * buttonWidth), width: 150, height: 30)
            buyButton?.addTarget(self, action: #selector(buyItem), for: .touchUpInside)
            self.view.addSubview(buyButton!)
            
            // restore button
            restoreButton = UIButton()
            restoreButton?.setTitle("بازیابی خرید", for: .normal)
            restoreButton?.setImage(UIImage(named: "restore"), for: .normal)
            restoreButton?.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.25)
            restoreButton?.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
            restoreButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            restoreButton?.setTitleColor(UIColor.black, for: UIControlState.normal)
            restoreButton?.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            restoreButton?.layer.borderWidth = 2
            restoreButton?.layer.cornerRadius = 5
            restoreButton?.layer.borderColor = UIColor(red:0.66, green:0.28, blue:0.28, alpha:1.0).cgColor
            restoreButton?.isExclusiveTouch = true
            restoreButton?.frame = CGRect(x: (defaultSize.width / 2)  - 160, y: defaultSize.height + (8 * buttonWidth), width: 150, height: 30)
            restoreButton?.addTarget(self, action: #selector(restore), for: .touchUpInside)
            self.view.addSubview(restoreButton!)
            
            // add buy description
            buyLabel = UILabel()
            buyLabel?.text = "برای تغییر شکلک ها نیاز هست تا برنامه را خریداری کنید. در صورتی که قبلا خریداری کرده اید روی بازیابی خرید تپ کنید."
            buyLabel?.font = UIFont.systemFont(ofSize: 14)
            buyLabel?.textColor = UIColor.darkGray
            buyLabel?.numberOfLines = 0
            buyLabel?.sizeToFit()
            buyLabel?.frame = CGRect(x: 10, y: defaultSize.height + (9 * buttonWidth), width: defaultSize.width - 20 , height: 50)
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
    
    // 0: emoji Off
    // 1: emoji On
    @IBAction func emojiSWChanged(_ sender: UISwitch) {
        if sender.isOn
        {
            // the switch changed to ON = 1
            emojiOnOff = 1
            prefs?.set(emojiOnOff, forKey: "emojiState")
            prefs?.synchronize()
            print("swich goes On")
            
        }
        else
        {
            // the switch changed to Off = 0
            emojiOnOff = 0
            prefs?.set(emojiOnOff, forKey: "emojiState")
            prefs?.synchronize()
            print("swich goes Off")
        }
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
                let alert = UIAlertController(title: "خطای کیبورد", message: "از کیبورد اِموجی استاندارد استفاده کنید.", preferredStyle:.alert)
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
            let alert = UIAlertController(title: "نسخه آزمایشی", message: "برای تغییر شکلک ها لطفا نسخه کامل را از اپ استور خریداری فرمایید.", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "شاید بعداً", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "خرید", style: .default, handler:buyEmojis))
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
                let alert = UIAlertController(title: "اتمام خرید", message: "خرید با موفقیت انجام شد. هم اکنون میتوانید شکلک ها را تغییر دهید.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
            case .failed:
                if let transactionError = transaction.error as? NSError {
                    if transactionError.code != SKError.paymentCancelled.rawValue {
                        let alert = UIAlertController(title: "خطا در خرید", message:transaction.error?.localizedDescription, preferredStyle: .alert)
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
                let alert = UIAlertController(title: "بازیابی خرید", message: "خرید شما با موفقیت بازیابی شد.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
        }
        let alert = UIAlertController(title: "بازیابی خرید", message: "خریدی یافت نشد!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}




