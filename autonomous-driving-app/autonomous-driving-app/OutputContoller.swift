//
//  SecondViewController.swift
//  autonomous-driving-app
//
//  Created by Kirsten Rauffer on 2/26/16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import UIKit

class OutputController: UIViewController {
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func request(sender: AnyObject) {
        
    }
    
    @IBAction func stop(sender: AnyObject) {
        
    }
    
    func setup() {
        requestButton.layer.cornerRadius = 37.5
        stopButton.layer.cornerRadius = 37.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}