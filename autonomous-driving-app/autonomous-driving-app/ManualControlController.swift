//
//  FirstViewController.swift
//  autonomous-driving-app
//
//  Created by Kirsten Rauffer on 2/26/16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import UIKit

class ManualControlController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    let share = ShareData.sharedInstance
    var run: Bool = false
    var speed: UInt8 = 0
    
    @IBAction func start(sender: AnyObject) {
        print("pressed start")
        run = true
    }
    
    @IBAction func stop(sender: AnyObject) {
        print("pressed stop")
        run = false
        setSpeed()
        share.remoteControl.setSpeedDirection(speed, direction: 50)
        share.remoteControl.setStop()
    }

    @IBAction func up(sender: AnyObject) {
        print("pressed up")
        setSpeed()
        share.remoteControl.setSpeedDirection(speed, direction: 50)
    }
    
    @IBAction func left(sender: AnyObject) {
        print("pressed left")
        setSpeed()
        share.remoteControl.setSpeedDirection(speed, direction: 0)
    }
    
    @IBAction func right(sender: AnyObject) {
        print("pressed right")
        setSpeed()
        share.remoteControl.setSpeedDirection(speed, direction: 100)
    }
    
    @IBAction func down(sender: AnyObject) {
        print("pressed down")
        speed = 201
        share.remoteControl.setSpeedDirection(speed, direction: 50)
    }
    
    func setSpeed(){
        if run {
            speed = 100
        } else {
            speed = 0
        }
    }

    func setUp() {
        startButton.layer.cornerRadius = 37.5
        stopButton.layer.cornerRadius = 37.5
        upButton.layer.cornerRadius = 15
        leftButton.layer.cornerRadius = 15
        rightButton.layer.cornerRadius = 15
        downButton.layer.cornerRadius = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

