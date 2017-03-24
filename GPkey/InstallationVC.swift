//
//  InstallationVC.swift
//  GPkey
//
//  Created by sohrab on 01/11/2016.
//  Copyright © 2016 ark. All rights reserved.
//

import UIKit

class InstallationVC: UIViewController, BWWalkthroughViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func installationTaped(_ sender: UIButton) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let mainBWW = main.instantiateViewController(withIdentifier: "InstallationBWW") as! BWWalkthroughViewController
        let page1 = main.instantiateViewController(withIdentifier: "step1BWW")
        let page2 = main.instantiateViewController(withIdentifier: "step2BWW")
        let page3 = main.instantiateViewController(withIdentifier: "step3BWW")
        let page4 = main.instantiateViewController(withIdentifier: "step4BWW")
        let page5 = main.instantiateViewController(withIdentifier: "step5BWW")
        let page6 = main.instantiateViewController(withIdentifier: "step6BWW")
        let page7 = main.instantiateViewController(withIdentifier: "step7BWW")
        
        mainBWW.delegate = self
        mainBWW.addViewController(page7)
        mainBWW.addViewController(page6)
        mainBWW.addViewController(page5)
        mainBWW.addViewController(page4)
        mainBWW.addViewController(page3)
        mainBWW.addViewController(page2)
        mainBWW.addViewController(page1)
        
        self.present(mainBWW, animated: true, completion: nil)
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
