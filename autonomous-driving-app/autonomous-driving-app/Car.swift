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
    
    init(ipv4: String){
        self.ipv4 = ipv4
        self.port = 3030
        
        speedFL = 0
        speedFR = 0
        speedBL = 0
        speedBR = 0

        x = 0
        y = 0
        z = 0

        d1 = 0
        d2 = 0
        d3 = 0
        d4 = 0
        d5 = 0
        d6 = 0
        d7 = 0
        d8 = 0
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
        default:
            break
        }
    }
}