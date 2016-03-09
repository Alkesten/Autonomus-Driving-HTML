//
//  RemoteControl.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 09.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation

class RemoteControl {
    let dataSocket: DataSocket
    let car: Car
    
    var instructions: [UInt8] = []
    
    init(dataSocket: DataSocket, car: Car){
        self.car = car
        self.dataSocket = dataSocket
    }
    
    func setSpeedDirection(speed: UInt8, direction: UInt8){
        let bytes: [UInt8] = [21, speed, direction]
        transmit(bytes)
    }
    
    func setStop(){
        let bytes: [UInt8] = [22]
        transmit(bytes)
    }
    
    func buildInstruction(cmd: UInt8){
        instructions.append(cmd)
    }
    
    func setTour(){
        instructions.insert(24, atIndex: 0)
        transmit(instructions)
    }
    
    func requestData(speed: Bool, gyroscope: Bool, distance: Bool, video: Bool){
        let id: UInt8 = 0x19
        var request: UInt8 = 0
        
        if(speed){
            request = request + 8
        }
        if(gyroscope){
            request = request + 4
        }
        if(distance){
            request = request + 2
        }
        if(video){
            request = request + 1
        }
        
        let buffer: [UInt8] = [id, request]
        
        transmit(buffer)
    }
    
    func transmit(bytes: [UInt8]){
        dataSocket.sendStream(bytes)
    }
}