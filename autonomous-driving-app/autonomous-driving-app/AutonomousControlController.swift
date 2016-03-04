//
//  SecondViewController.swift
//  autonomous-driving-app
//
//  Created by Kirsten Rauffer on 2/26/16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import UIKit

class AutonomousControlController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addAction(sender: AnyObject) {
    
    }
    
    @IBAction func start(sender: AnyObject) {
    
    }
    
    @IBAction func stop(sender: AnyObject) {
    
    }

    func setup() {
        startButton.layer.cornerRadius = 37.5
        stopButton.layer.cornerRadius = 37.5
        addButton.layer.cornerRadius = 16
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

