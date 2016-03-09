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
    var car: Car
    let localPort: UInt16
    
    init(car: Car, localPort: UInt16){
        self.car = car
        self.localPort = localPort
    }
    
    func convertUInt16ToUInt8(uInt16Value: UInt16) -> [UInt8]{
        let uInt8Value0 = UInt8(uInt16Value >> 8)
        let uInt8Value1 = UInt8(uInt16Value & 0x00ff)
        
        let byte: [UInt8] = [uInt8Value0, uInt8Value1]
        
        return byte
    }
    
    func udpSocket(sock : GCDAsyncUdpSocket!, didReceiveData data : NSData!,  fromAddress address : NSData!,  withFilterContext filterContext : AnyObject!) {
        print(data)
        car.processRxData(data)
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
    
    func sendString(message: String){
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        udpSocket.sendData(data, withTimeout: 2, tag: 0)
    }
}
