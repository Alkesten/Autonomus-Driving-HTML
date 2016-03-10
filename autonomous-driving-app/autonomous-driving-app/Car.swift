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
    
    var distance: [UInt8]
    var xyz: [UInt8]
    var speed: [UInt8]
    
    var instructions = []
    
    init(ipv4: String){
        self.ipv4 = ipv4
        self.port = 3030
        
        distance = [0,0,0,0,0,0,0,0]
        speed = [0,0,0,0]
        xyz = [0,0,0]
        
        print("new car created")
    }

    func writeSpeed(speed: [UInt8]){
        self.speed = speed
    }
    
    func writeGyroscope(xyz: [UInt8]){
        self.xyz = xyz
    }
    
    func writeDistance(distance: [UInt8]){
        self.distance = distance
    }
}