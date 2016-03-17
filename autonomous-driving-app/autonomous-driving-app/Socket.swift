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
    let shared = ShareData.sharedInstance
    let localPort: UInt16 //the local UDP port of the app (data or video)
    
    init(localPort: UInt16){
        self.localPort = localPort
        debugPrint("new Socket created")
    }
    
    //Converts UInt16 to [UInt8] (big endian)
    func convertUInt16ToUInt8(uInt16Value: UInt16) -> [UInt8]{
        let uInt8Value0 = UInt8(uInt16Value >> 8)   //extracts the first UInt8 by bit shifting
        let uInt8Value1 = UInt8(uInt16Value & 0x00ff)   //extracts the second UInt8 by adding 0x00FF
        
        let uInt8Array: [UInt8] = [uInt8Value0, uInt8Value1]    //concatinate booth UInt8 Values

        debugPrint("convert UInt16: \(uInt16Value) to [UInt8]: \(uInt8Array)")
        
        return uInt8Array
    }
    
    //Converts [UInt8] to UInt16 (big endian)
    func convertUInt8ToUInt16(uInt8Array: [UInt8]) -> UInt16{
        var uInt16Value = UnsafePointer<UInt16>(uInt8Array).memory  //extracts UInt16 by memory access of [UInt8]
        uInt16Value = uInt16Value.bigEndian //converts to big endian
        
        debugPrint("convert [UInt8]: \(uInt8Array) to UInt16: \(uInt16Value) (big endian)")

        return uInt16Value
    }
    
    //reads the ID and calls the required function to process data
    func processRxData(data: NSData){
        //constants for the UnsafeBufferPointer
        let pointer = UnsafePointer<UInt8>(data.bytes)
        let count = data.length
        
        //gets the Bytearray from the NSData
        let bufferPtr = UnsafeBufferPointer<UInt8>(start: pointer, count: count)
        let buffer = [UInt8](bufferPtr)
        var payload = buffer
        payload.removeFirst() //Payload without the ID
        
        let id: UInt8 = buffer.first! //The ID of the received datagram
        
        //Analyze the ID and calls the dedicated function (IDs specified in TransmissionProtocol.md)
        switch id {
        case 11:
            debugPrint("ID 11 = Speed")
            shared.car.writeSpeed(payload)
        case 12:
            debugPrint("ID 12 = Gyroscope")
            shared.car.writeGyroscope(payload)
        case 13:
            debugPrint("ID 13 = Distance")
            var payloadUInt16: [UInt16] = [] //UInt16 Array for distance 1-8
            var uInt16Distance: UInt16
            
            //decodes the recieved UInt8 pairs for each UInt16 distance value
            for var i = 0; i < payload.count; i = i + 2 {
                uInt16Distance = convertUInt8ToUInt16([payload[i], payload[i+1]])
                payloadUInt16.append(uInt16Distance)
            }
                
            shared.car.writeDistance(payloadUInt16)
        case 14:
            debugPrint("ID 14 = Video")
            break //TODO
        case 15:
            debugPrint("ID 15 = Instruction")
            shared.car.writeInstructions(payload) //saves received instructions without ID
        default:
            debugPrint("ID \(id) = Unknown!")
            break
        }
    }
    
    //sends a String via UDP. (Just for testing, to send data use sendStream(byteArray: [UInt8]))
    func sendString(message: String){
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        udpSocket.sendData(data, withTimeout: 2, tag: 0)
    }
    
    
    /*
    CocoaAsyncSocket Framework functions
    http://cocoadocs.org/docsets/CocoaAsyncSocket/7.4.1/
    */
    func udpSocket(sock : GCDAsyncUdpSocket!, didReceiveData data : NSData!,  fromAddress address : NSData!,  withFilterContext filterContext : AnyObject!) {
        debugPrint("Received: \(data)")
        processRxData(data) //sends received data to the function to distinguish between the IDs
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        //debugPrint("didConnectToAddress")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        //debugPrint("didNotConnect \(error)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        //debugPrint("didSendDataWithTag")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        //debugPrint("didNotSendDataWithTag")
    }
    /*
    CocoaAsyncSocket Framework END
    */
}

