//
//  DataSocket.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 09.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


class DataSocket: Socket {
    
    override init(car: Car, localPort: UInt16) {
        super.init(car: car, localPort: localPort)
        setupConnection()
        print("new DataSocket created")
    }

    func setupConnection(){
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        do {
            try udpSocket.bindToPort(localPort)
            try udpSocket.connectToHost(car.ipv4, onPort: car.port)
            try udpSocket.beginReceiving()
        } catch let err as NSError {
            err.description
        }
        super.sendString("DataSocketEstablished")
    }
    
    func handshake(videoPort: UInt16, dataPort: UInt16){
        let dataPortA = convertUInt16ToUInt8(dataPort)
        let videoPortA = convertUInt16ToUInt8(videoPort)
        
        let buffer: [UInt8] = [20] + dataPortA + videoPortA
        
        sendStream(buffer)
        
        print("sent handshake dataPort: \(dataPort) , videoPort: \(videoPort)")
    }
    
    func sendStream(byteArray: [UInt8]){
        let data: NSData = NSData(bytes: byteArray as [UInt8], length: byteArray.count)
        udpSocket.sendData(data, withTimeout: 2, tag: 0)
    }
}