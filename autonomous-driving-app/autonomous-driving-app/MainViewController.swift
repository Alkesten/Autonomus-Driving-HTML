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
        print("pressed enter")
        var ipv4 = ""
        
        if let ip = IPAddress.text {
            ipv4 = ip
        } else {
            print("Ip Address is nil")
            warningLabel.text = "PLEASE USE FORMAT 123.45.67.89"
        }
        
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        
        if (ipv4.rangeOfString(validIpAddressRegex, options: .RegularExpressionSearch) != nil){
            print("\(ipv4) is a valid IP address")
            
            ShareData.sharedInstance.car = Car.init(ipv4: ipv4)
            shared.dataSocket = DataSocket(car: shared.car, localPort: shared.dataPort)
            shared.videoSocket = VideoSocket(car: shared.car, localPort: shared.videoPort)
            
            shared.dataSocket.handshake(shared.videoPort, dataPort: shared.dataPort)
            shared.remoteControl = RemoteControl(dataSocket: shared.dataSocket, car: shared.car)
            
            self.performSegueWithIdentifier("nextScreen", sender: self)
        } else {
            print("Ip Address \(ipv4) is not valid.")
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
