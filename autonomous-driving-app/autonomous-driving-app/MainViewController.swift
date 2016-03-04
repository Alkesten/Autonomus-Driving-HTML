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
    
    @IBAction func enter(sender: AnyObject) {
        
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
