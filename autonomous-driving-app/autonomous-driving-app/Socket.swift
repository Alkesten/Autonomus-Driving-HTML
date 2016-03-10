//
//  Socket.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 04.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class Socket: NSObject, GCDAsyncUdpSocketDelegate{
    
    var udpSocket: GCDAsyncUdpSocket!
    let car: Car
    let video: Video
    let localPort: UInt16
    
    init(car: Car, video: Video, localPort: UInt16){
        self.car = car
        self.video = video
        self.localPort = localPort
    }
    
    func convertUInt16ToUInt8(uInt16Value: UInt16) -> [UInt8]{
        let uInt8Value0 = UInt8(uInt16Value >> 8)
        let uInt8Value1 = UInt8(uInt16Value & 0x00ff)
        
        let byte: [UInt8] = [uInt8Value0, uInt8Value1]
        
        return byte
    }
       
    func udpSocket(sock : GCDAsyncUdpSocket!, didReceiveData data : NSData!,  fromAddress address : NSData!,  withFilterContext filterContext : AnyObject!) {
        print("Received: \(data)")
        processRxData(data)
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        print("didConnectToAddress")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        print("didNotConnect \(error)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        print("didSendDataWithTag")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        print("didNotSendDataWithTag")
    }
    
    func processRxData(data: NSData){
        let pointer = UnsafePointer<UInt8>(data.bytes)
        let count = data.length
        
        let buffer = UnsafeBufferPointer<UInt8>(start:pointer, count:count)
        let array = [UInt8](buffer)
        var payload = array
        payload.removeFirst()
        
        let id: UInt8 = buffer[0]
        
        switch id {
        case 11:
            car.writeSpeed(payload)
        case 12:
            car.writeGyroscope(payload)
        case 13:
            car.writeDistance(payload)
        case 14:
            //TODO
            break
        default:
            break
        }
    }
    
    func sendString(message: String){
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        udpSocket.sendData(data, withTimeout: 2, tag: 0)
    }
}
