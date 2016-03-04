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
    
    var d1,d2,d3,d4,d5,d6,d7,d8: UInt8
    var x, y, z: UInt8 //gyroscope oder: [x,y,z]
    var speedFL, speedFR, speedBL, speedBR: UInt8 //order: [front left, front right, back left, back right]
    
    var instructions = []
    
    init(ipv4: String, port: UInt16){
        self.ipv4 = ipv4
        self.port = port
    }
    
    func processRxData(data: NSData){
        let pointer = UnsafePointer<UInt8>(data.bytes)
        let count = data.length
        
        let buffer = UnsafeBufferPointer<UInt8>(start:pointer, count:count)
        let array = [UInt8](buffer)
        
        let id: UInt8 = buffer[0]
        
        switch id {
            case 11:
                speedFL = array[1]
                speedFR = array[2]
                speedBL = array[3]
                speedBR = array[4]
            case 12:
                x = array[1]
                y = array[2]
                z = array[3]
            case 13:
                d1 = array[1]
                d2 = array[2]
                d3 = array[3]
                d4 = array[4]
                d5 = array[5]
                d6 = array[6]
                d7 = array[7]
                d8 = array[8]

        }
    }
}