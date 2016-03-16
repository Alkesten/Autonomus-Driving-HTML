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
    let localPort: UInt16
    
    init(car: Car, localPort: UInt16){
        self.car = car
        self.localPort = localPort
        print("new Socket created")
    }
    
    func convertUInt16ToUInt8(uInt16Value: UInt16) -> [UInt8]{
        let uInt8Value0 = UInt8(uInt16Value >> 8)
        let uInt8Value1 = UInt8(uInt16Value & 0x00ff)
        
        let byte: [UInt8] = [uInt8Value0, uInt8Value1]
        
        return byte
    }
    
    func convertUInt8ToUInt8(uInt8Value: [UInt8]) -> UInt16{
        let u16 = UnsafePointer<UInt16>(uInt8Value).memory
        return u16.bigEndian
    }
       
    func udpSocket(sock : GCDAsyncUdpSocket!, didReceiveData data : NSData!,  fromAddress address : NSData!,  withFilterContext filterContext : AnyObject!) {
        print("Received: \(data)")
        processRxData(data)
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        //print("didConnectToAddress")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        //print("didNotConnect \(error)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        //print("didSendDataWithTag")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        //print("didNotSendDataWithTag")
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
            print("ID 11 = Speed")
            car.writeSpeed(payload)
        case 12:
            print("ID 12 = Gyroscope")
            car.writeGyroscope(payload)
        case 13:
            print("ID 13 = Distance")
            var payloadUInt16: [UInt16] = []
            
            for var i = 0; i < payload.count; i = i + 2 {
                payloadUInt16.append(convertUInt8ToUInt8([payload[i], payload[i+1]]))
            }
                
            car.writeDistance(payloadUInt16)
        case 14:
            print("ID 14 = Video")
            //TODO
            break
        default:
            print("ID \(id) = Unknown!")
            break
        }
    }
    
    func sendString(message: String){
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        udpSocket.sendData(data, withTimeout: 2, tag: 0)
    }
}
