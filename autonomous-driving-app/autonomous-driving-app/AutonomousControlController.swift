//
//  SecondViewController.swift
//  autonomous-driving-app
//
//  Created by Kirsten Rauffer on 2/26/16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import UIKit

class AutonomousControlController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var actionOptions: UIView!
    @IBOutlet weak var actions: UITableView!
    
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
    
    @IBAction func forward(sender: AnyObject) {
        hideMenu()
        actionsArray.append("Forward")
        updateValues()
    }
    
    @IBAction func backward(sender: AnyObject) {
        hideMenu()
        actionsArray.append("Backward")
        updateValues()
    }
    
    @IBAction func left(sender: AnyObject) {
        hideMenu()
        actionsArray.append("Turn Left")
        updateValues()
    }
    
    @IBAction func right(sender: AnyObject) {
        hideMenu()
        actionsArray.append("Turn Right")
        updateValues()
    }
    
    @IBAction func park(sender: AnyObject) {
        hideMenu()
        actionsArray.append("Park")
        updateValues()
    }
    
    @IBAction func stop(sender: AnyObject) {
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
        actions.delegate = self
        actions.dataSource = self
        actions.tableFooterView = UIView()

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

