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
    @IBOutlet weak var actionOptions: UIView!
    var active = false

    func showMenu() {
        addButton.setImage(UIImage(named: "remove.png"), forState: .Normal)
        actionOptions.hidden = false
    }
    
    func hideMenu() {
        addButton.setImage(UIImage(named: "add.png"), forState: .Normal)
        actionOptions.hidden = true
    }
    
    @IBAction func forward(sender: AnyObject) {
        hideMenu()
    }
    
    @IBAction func backward(sender: AnyObject) {
        hideMenu()
    }
    
    @IBAction func left(sender: AnyObject) {
        hideMenu()
    }
    
    @IBAction func right(sender: AnyObject) {
        hideMenu()
    }
    
    @IBAction func park(sender: AnyObject) {
        hideMenu()
    }
    
    @IBAction func stop(sender: AnyObject) {
        hideMenu()
    }
    
    @IBAction func addAction(sender: AnyObject) {
        if active == false {
            active = true
            showMenu()
        } else {
            active = false
            hideMenu()
        }
    }
    
    @IBAction func start(sender: AnyObject) {
        
    
    }
    
    @IBAction func emergencyStop(sender: AnyObject) {
    
    }

    func setup() {
        startButton.layer.cornerRadius = 37.5
        stopButton.layer.cornerRadius = 37.5
        addButton.layer.cornerRadius = 16
        actionOptions.hidden = true
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

