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
    
    var distance: [(String, UInt16)]
    var speed: [(String, UInt8)]
    var xyz: [(String, UInt8)]

    var instructions = []
    
    init(ipv4: String){
        self.ipv4 = ipv4
        self.port = ShareData.sharedInstance.carPort
        
        distance = [("Front Left",0),("Front",0),("Front Right",0),("Right",0),("Back Right",0),("Back",0),("Back Left",0),("Left",0)]
        speed = [("Front Left",0),("Front Right",0),("Back Right",0),("Back Left",0)]
        xyz = [("X",0),("Y",0),("Z",0)]
        
        print("new car created")
    }

    func writeSpeed(speed: [UInt8]){
        self.speed = [("Front Left",speed[0]),("Front Right",speed[1]),("Back Left",speed[2]),("Back Right",speed[3])]
        print("Speed saved")
    }
    
    func writeGyroscope(xyz: [UInt8]){
        self.xyz = [("X",xyz[0]),("Y",xyz[1]),("Z",xyz[2])]
        print("Gyroscope saved")
    }
    
    func writeDistance(distance: [UInt16]){
        self.distance = [("Front Left",distance[0]),("Front",distance[1]),("Front Right",distance[2]),("Right",distance[3]),("Back Right",distance[4]),("Back",distance[5]),("Back Left",distance[6]),("Left",distance[7])]
        print("Distance saved")
    }
}
