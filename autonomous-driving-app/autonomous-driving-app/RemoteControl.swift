//
//  RemoteControl.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 09.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation

class RemoteControl {
    
    var instructions: [UInt8] = []
    let dataSocket = ShareData.sharedInstance.dataSocket
    
    //sends speed and direction to the car (ID: 21)
    func setSpeedDirection(speed: UInt8, direction: UInt8){
        let bytes: [UInt8] = [21, speed, direction]
        dataSocket.sendStream(bytes)
        debugPrint("sent speed/direction \(bytes)")
    }
    
    //sends a stop signal to the car (ID 22)
    func setStop(){
        let bytes: [UInt8] = [22]
        dataSocket.sendStream(bytes)
        debugPrint("sent stop \(bytes)")
    }
    
    //append a new command to the instruction list. For sending use setTour()
    func buildInstruction(cmd: UInt8){
        instructions.append(cmd)
        debugPrint("add instruction \(cmd)")
    }
    
    //sends the builded instruction list (ID: 24)
    func setTour(){
        ShareData.sharedInstance.car.writeInstructions(instructions)    //add instruction to car object
        
        instructions.insert(24, atIndex: 0) //adds ID
        dataSocket.sendStream(instructions)
        debugPrint("set tour send sent \(instructions)")
    }
    
    //requests data from the car (ID 0x19)
    func requestData(speed: Bool, gyroscope: Bool, distance: Bool, video: Bool){
        let id: UInt8 = 0x19
        var request: UInt8 = 0
        /*
        requestet datatypes (1 byte):
            speed (0b0000 1000 = 0x08)
            gyroscope (0000 0100 = 0x04)
            distance (0000 0010 = 0x02)
            video (0000 0001 = 0x01)
                example: request speed and distance: 0b0000 1000 + 0b0000 0010 = 0b0000 1010 = 0x0A
        */
        
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
        
        dataSocket.sendStream(buffer)
        debugPrint("sent request \(request)")
    }
}
