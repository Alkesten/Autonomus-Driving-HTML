//
//  SecondViewController.swift
//  autonomous-driving-app
//
//  Created by Kirsten Rauffer on 2/26/16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import UIKit

class AutonomousControlController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var actionOptions: UIView!
    @IBOutlet weak var actions: UITableView!
    
    let shared = ShareData.sharedInstance
    var actionsArray: [String] = []
    var active = false

    func showMenu() {
        active = true
        addButton.setImage(UIImage(named: "remove.png"), forState: .Normal)
        actionOptions.hidden = false
    }
    
    func hideMenu() {
        active = false
        addButton.setImage(UIImage(named: "add.png"), forState: .Normal)
        actionOptions.hidden = true
    }
    
    //instructions: range between 0 and 4: 0 = turn left, 1 = go straight, 2 = turn right, park = 3, stop = 4
    @IBAction func forward(sender: AnyObject) {
        shared.remoteControl.buildInstruction(1) //adds the command to the tour list
        hideMenu()
        actionsArray.append("Forward")
        updateValues()
    }
    
    @IBAction func left(sender: AnyObject) {
        shared.remoteControl.buildInstruction(0)    //adds the command to the tour list
        hideMenu()
        actionsArray.append("Turn Left")
        updateValues()
    }
    
    @IBAction func right(sender: AnyObject) {
        shared.remoteControl.buildInstruction(2)    //adds the command to the tour list
        hideMenu()
        actionsArray.append("Turn Right")
        updateValues()
    }
    
    @IBAction func park(sender: AnyObject) {
        shared.remoteControl.buildInstruction(3)    //adds the command to the tour list
        hideMenu()
        actionsArray.append("Park")
        updateValues()
    }
    
    @IBAction func stop(sender: AnyObject) {
        shared.remoteControl.buildInstruction(4)    //adds the command to the tour list
        hideMenu()
        actionsArray.append("Stop")
        updateValues()
    }
    
    @IBAction func addAction(sender: AnyObject) {
        if active == false {
            showMenu()
        } else {
            hideMenu()
        }
    }
    
    @IBAction func start(sender: AnyObject) {
        debugPrint("pressed start")
        shared.remoteControl.setTour() //sends the builded tour
    }
    
    @IBAction func emergencyStop(sender: AnyObject) {
        debugPrint("pressed stop")
        shared.remoteControl.setStop() //sends stop signal
    }

    func setup() {
        startButton.layer.cornerRadius = 37.5
        stopButton.layer.cornerRadius = 37.5
        addButton.layer.cornerRadius = 16
        hideMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        actions.delegate = self
        actions.dataSource = self
        actions.tableFooterView = UIView()
        ShareData.sharedInstance.remoteControl.requestData(false, gyroscope: false, distance: false, video: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellAction = actionsArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("actionCell", forIndexPath: indexPath)
        cell.textLabel?.text = cellAction
        cell.textLabel?.textColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let index = indexPath.row
            actionsArray.removeAtIndex(index)
            updateValues()
        }
    }
    
    func updateValues() {
        actions.reloadData()
    }
}

