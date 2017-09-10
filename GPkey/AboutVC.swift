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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.allowsSelection = false
        table.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    @IBAction func reportABug(_ sender: UIButton) {
        
        let subject = "Report GachPazh Bug"
        var body = "Please fully explain the sitations:"
        body = body + "\n\n\n\n"
        body = body + "--- device Inofrmation ---"
        body = body + "\n"
        body = body + "Device Model: " + platform() + "\n"
        body = body + "iOS version: " + UIDevice.current.systemVersion + "\n"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            body = body + "GP version:" + version
        }
        
        let coded = "mailto:me@alirezak.me?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL: NSURL = NSURL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.openURL(emailURL as URL)
            }
        }
    }
    
    
    @IBAction func visitNounProject(_ sender: UIButton) {
        if let url = URL(string: "https://thenounproject.com")
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
