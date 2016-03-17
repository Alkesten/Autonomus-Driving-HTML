//
//  MainViewController.swift
//  autonomous-driving-app
//
//  Created by Kirsten Rauffer on 2/28/16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var IPAddress: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    let shared = ShareData.sharedInstance
    
    @IBAction func enter(sender: AnyObject) {
        debugPrint("pressed enter")
        var ipv4 = ""
        
        //gets String from texfield
        if let ip = IPAddress.text {
            ipv4 = ip
        } else {
            //no value entered
            debugPrint("Ip Address is nil")
            warningLabel.text = "PLEASE USE FORMAT 123.45.67.89"
        }
        
        //a valid IP Address Regex pattern to compare
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        
        //checks if the entered IP is valid
        if (ipv4.rangeOfString(validIpAddressRegex, options: .RegularExpressionSearch) != nil){
            debugPrint("\(ipv4) is a valid IP address")
            
            //creats the car, sockets and remotecontrol in the shared instance accessable for every class.
            ShareData.sharedInstance.ini(ipv4, carPort: 3030, dataPort: 3040, videoPort: 3050)
            
            self.performSegueWithIdentifier("nextScreen", sender: self) //go to next screen
        } else {
            //requests a valid IP if the entered wasn't valid.
            debugPrint("Ip Address \(ipv4) is not valid.")
            warningLabel.text = "PLEASE USE FORMAT 123.45.67.89"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialize()
    }
    
    func intialize() {
        IPAddress.textRectForBounds(CGRectInset(IPAddress.bounds, 0, 0))
        IPAddress.editingRectForBounds(CGRectInset(IPAddress.bounds, 0, 0))
        warningLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
