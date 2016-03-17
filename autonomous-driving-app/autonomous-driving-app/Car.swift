//
//  Car.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 04.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation

class Car {
    
    let port: UInt16
    let ipv4: String
    
    //init vars with 0
    var distance: [(String, UInt16)] = [("Front Left",0),("Front",0),("Front Right",0),("Right",0),("Back Right",0),("Back",0),("Back Left",0),("Left",0)]
    var speed: [(String, UInt8)] = [("Front Left",0),("Front Right",0),("Back Right",0),("Back Left",0)]
    var xyz: [(String, UInt8)] = [("X",0),("Y",0),("Z",0)]
    var instructions: [UInt8] = []
    
    init(ipv4: String, port: UInt16){
        self.ipv4 = ipv4
        self.port = port
        
        debugPrint("new car created with address: \(ipv4):\(port)")
    }
    
    
    /*
    Saves the received values in the dictionaries
    */
    func writeSpeed(speed: [UInt8]){
        self.speed = [("Front Left",speed[0]),("Front Right",speed[1]),("Back Left",speed[2]),("Back Right",speed[3])]
        debugPrint("Speed saved")
    }
    
    func writeGyroscope(xyz: [UInt8]){
        self.xyz = [("X",xyz[0]),("Y",xyz[1]),("Z",xyz[2])]
        debugPrint("Gyroscope saved")
    }
    
    func writeDistance(distance: [UInt16]){
        self.distance = [("Front Left",distance[0]),("Front",distance[1]),("Front Right",distance[2]),("Right",distance[3]),("Back Right",distance[4]),("Back",distance[5]),("Back Left",distance[6]),("Left",distance[7])]
        debugPrint("Distance saved")
    }
    
    func writeInstructions(instructions: [UInt8]){
        self.instructions = instructions
        debugPrint("Instructions saved")
    }
}
