//
//  SecondViewController.swift
//  autonomous-driving-app
//
//  Created by Kirsten Rauffer on 2/26/16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import UIKit

class OutputController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var outputTable: UITableView!
    
    //need to put actual data where the dummy data is
    var outputData: [(String, Double)] = [("Speed",123.45),("Gyroscope",123.55),("Distance",123.35)]
    
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
        outputTable.delegate = self
        outputTable.dataSource = self
        outputTable.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return outputData[section].0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return outputData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellData = outputData[indexPath.section].1
        
        let cell = tableView.dequeueReusableCellWithIdentifier("outputCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(cellData)"
        cell.textLabel?.textColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func updateValues() {
        outputTable.reloadData()
    }
    
}