//
//  Socket.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 04.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class Socket: GCDAsyncSocketDelegate{
    
    let localPort: UInt16
    var udpSocket: GCDAsyncUdpSocket!
    var car: Car
    
    init(car: Car, port: UInt16)
    {
        super.init()
        self.car = car
        self.localPort = port
        setupConnection()
    }
    
    func setupConnection(){
        var error : NSError?
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        udpSocket.bindToPort(localPort, error: &error)
        udpSocket.connectToHost(car.ipv4, onPort: car.port, error: &error)
        udpSocket.beginReceiving(&error)
        sendString("HelloCar")
    }
    
    func handshake(videoPort: UInt16, dataPort: UInt16){
        
        var buffer: [UInt8] = [20, dataPort, videoPort]
    }
    
    func udpSocket(sock : GCDAsyncUdpSocket!, didReceiveData data : NSData!,  fromAddress address : NSData!,  withFilterContext filterContext : AnyObject!) {
        println(data)
        car.processRxData(data)
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        println("didConnectToAddress");
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        println("didNotConnect \(error)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        println("didSendDataWithTag")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        println("didNotSendDataWithTag")
    }

    func disconnect() -> Bool
    {
        if udpSocket
        {
            udpSocket!.disconnect()
            return true
        }
        return false
    }
    
    func sendString(message:string){
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        udpSocket.sendData(data, withTimeout: 2, tag: 0)
    }
    
    func sendStream(bytes: [UInt8]){
        udpSocket.sendData(bytes, withTimeout: 2, tag: 0)
    }

}
