//
//  Remote.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 04.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation

class Remote {
    let socket: Socket
    let car: Car
    
    var instructions: [UInt8] = []
    
    init(socket: Socket, car: Car){
        self.car = car
        self.socket = socket
    }
    
    func setSpeedDirection(speed: UInt8, direction: UInt8){
        var bytes: [UInt8] = [21, speed, direction]
        transmit(bytes)
    }
    
    func setStop(){
        var bytes: [UInt8] = [22]
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
        var id: UInt8 = 0x19
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
    
        var buffer: [UInt8] = [id, request]
        
        transmit(buffer)
    }
    
    func transmit(bytes: [UInt8]){
        socket.sendStream(bytes)
    }
}