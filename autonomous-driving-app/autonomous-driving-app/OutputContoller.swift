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
    @IBOutlet weak var outputTable: UITableView!
    
    @IBOutlet weak var frontTire: UILabel!
    @IBOutlet weak var leftTire: UILabel!
    @IBOutlet weak var rightTire: UILabel!
    @IBOutlet weak var backTire: UILabel!
    
    @IBOutlet weak var frontDistance: UILabel!
    @IBOutlet weak var backDistance: UILabel!
    @IBOutlet weak var frontLeftDistance: UILabel!
    @IBOutlet weak var backLeftDistance: UILabel!
    @IBOutlet weak var frontRightDistance: UILabel!
    @IBOutlet weak var backRightDistance: UILabel!
    @IBOutlet weak var leftDistance: UILabel!
    @IBOutlet weak var rightDistance: UILabel!
    
    @IBOutlet weak var xGyroscope: UILabel!
    @IBOutlet weak var yGyroscope: UILabel!
    @IBOutlet weak var zGyroscope: UILabel!
    
    let shared = ShareData.sharedInstance
    
    @IBAction func request(sender: AnyObject) {
        debugPrint("pressed request")
        shared.remoteControl.requestData(true, gyroscope: true, distance: true, video: false) //request all data except video
    }
    
    @IBAction func stop(sender: AnyObject) {
        debugPrint("pressed stop")
        shared.remoteControl.setStop() //sends stop signal, still receive data for output
    }
    
    func setup() {
        requestButton.layer.cornerRadius = 37.5
        stopButton.layer.cornerRadius = 37.5
        updateValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateValues"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateValues() {
        dispatch_async(dispatch_get_main_queue(), {
            self.frontTire.text = "\(ShareData.sharedInstance.car.speed[0].0): \(Double(ShareData.sharedInstance.car.speed[0].1))"
            self.leftTire.text = "\(ShareData.sharedInstance.car.speed[1].0): \(Double(ShareData.sharedInstance.car.speed[1].1))"
            self.rightTire.text = "\(ShareData.sharedInstance.car.speed[2].0): \(Double(ShareData.sharedInstance.car.speed[2].1))"
            self.backTire.text = "\(ShareData.sharedInstance.car.speed[3].0): \(Double(ShareData.sharedInstance.car.speed[3].1))"
            
            self.frontDistance.text = "\(ShareData.sharedInstance.car.distance[1].0): \(Double(ShareData.sharedInstance.car.distance[1].1))"
            self.backDistance.text = "\(ShareData.sharedInstance.car.distance[5].0): \(Double(ShareData.sharedInstance.car.distance[5].1))"
            self.frontLeftDistance.text = "\(ShareData.sharedInstance.car.distance[2].0): \(Double(ShareData.sharedInstance.car.distance[2].1))"
            self.frontRightDistance.text = "\(ShareData.sharedInstance.car.distance[0].0): \(Double(ShareData.sharedInstance.car.distance[0].1))"
            self.backLeftDistance.text = "\(ShareData.sharedInstance.car.distance[4].0): \(Double(ShareData.sharedInstance.car.distance[4].1))"
            self.backRightDistance.text = "\(ShareData.sharedInstance.car.distance[6].0): \(Double(ShareData.sharedInstance.car.distance[6].1))"
            self.leftDistance.text = "\(ShareData.sharedInstance.car.distance[7].0): \(Double(ShareData.sharedInstance.car.distance[7].1))"
            self.rightDistance.text = "\(ShareData.sharedInstance.car.distance[3].0): \(Double(ShareData.sharedInstance.car.distance[3].1))"
            
            self.xGyroscope.text = "\(ShareData.sharedInstance.car.xyz[0].0): \(Double(ShareData.sharedInstance.car.xyz[0].1))"
            self.yGyroscope.text = "\(ShareData.sharedInstance.car.xyz[1].0): \(Double(ShareData.sharedInstance.car.xyz[1].1))"
            self.zGyroscope.text = "\(ShareData.sharedInstance.car.xyz[2].0): \(Double(ShareData.sharedInstance.car.xyz[2].1))"
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateValues()
    }
}
