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
    
    var car: Car!
    var dataSocket: DataSocket!
    var videoSocket: VideoSocket!
    
    @IBAction func enter(sender: AnyObject) {
        var ipv4 = ""
        
        if let ip = IPAddress.text {
            ipv4 = ip
        } else {
            print("Ip Address is nil")
        }
        
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        
        if (ipv4.rangeOfString(validIpAddressRegex, options: .RegularExpressionSearch) != nil){
            print("\n\n \(ipv4) is a valid IP address\n\n")
            car = Car.init(ipv4: ipv4)
            self.performSegueWithIdentifier("nextScreen", sender: self)
        } else {
            print("Ip Address \(ipv4) is not valid.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
