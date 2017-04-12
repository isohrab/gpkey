//
//  AboutVC.swift
//  GPkey
//
//  Created by sohrab on 01/11/2016.
//  Copyright © 2016 ark. All rights reserved.
//

import UIKit

class AboutVC: UITableViewController {

    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var comment1: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //table.allowsSelection = false
        
        comment1.font = UIFont(name: "Parastoo", size: 14)
        
    }

    @IBAction func telegramTaped(_ sender: UIButton) {
        if let url = URL(string: "http://alirezak.me/gachpazh-keyboard.php") {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
    
    @IBAction func reportABug(_ sender: UIButton) {
        
        if let url = URL(string: "mailto:me@alirezak.me") {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func visitNounProject(_ sender: UIButton) {
        if let url = URL(string: "https://thenounproject.com")
        {
            UIApplication.shared.openURL(url)
        }
    }
}
