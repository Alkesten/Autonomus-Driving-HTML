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
    
    let shared = ShareData.sharedInstance
    var run: Bool = false //only if run is true speed will be set to 100 (except backward driving)
    var speed: UInt8 = 0 //0 = no speed, 1-100 = forward, 101-200 backward
    
    @IBAction func start(sender: AnyObject) {
        debugPrint("pressed start")
        run = true
    }
    
    @IBAction func stop(sender: AnyObject) {
        debugPrint("pressed stop")
        run = false
        setSpeed() //sets speed to 0 beacuse run = false
        shared.remoteControl.setSpeedDirection(speed, direction: 50) //sends speed = 0
        shared.remoteControl.setStop() //sends stop signal to car
    }

    @IBAction func up(sender: AnyObject) {
        debugPrint("pressed up")
        setSpeed()
        shared.remoteControl.setSpeedDirection(speed, direction: 50) //50 is for straight
    }
    
    @IBAction func left(sender: AnyObject) {
        debugPrint("pressed left")
        setSpeed()
        shared.remoteControl.setSpeedDirection(speed, direction: 0) //0 is for left
    }
    
    @IBAction func right(sender: AnyObject) {
        debugPrint("pressed right")
        setSpeed()
        shared.remoteControl.setSpeedDirection(speed, direction: 100)   //100 is for right
    }
    
    @IBAction func down(sender: AnyObject) {
        debugPrint("pressed down")
        //check if stop was pressed
        if (run){
            speed = 200
            shared.remoteControl.setSpeedDirection(speed, direction: 50) //50 is for straight (even back)
        }
    }
    
    //checks if stop was pressed
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
        ShareData.sharedInstance.remoteControl.requestData(false, gyroscope: false, distance: false, video: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

