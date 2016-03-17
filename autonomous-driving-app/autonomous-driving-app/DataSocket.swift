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
    
    override init(localPort: UInt16) {
        super.init(localPort: localPort)
        setupConnection()
        debugPrint("new DataSocket created")
    }

    //connects the DataSocket to the port and ip of the car, binds it to the local port and starts receiving
    func setupConnection(){
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        do {
            try udpSocket.bindToPort(localPort) //binds the socket to the local port
            try udpSocket.connectToHost(shared.car.ipv4, onPort: shared.car.port) //connects to the car by port and IP
            try udpSocket.beginReceiving() //starts receiving
        } catch let err as NSError {
            err.description
        }
        debugPrint("DataSocket \(self) bound to \(localPort) with car \(shared.car.ipv4):\(shared.car.port)")
        super.sendString("DataSocketEstablished")
    }
    
    //sends the UDP ports of the app to the car. Should be called after creating booth sockets.
    func handshake(videoPort: UInt16, dataPort: UInt16){
        //converts the UInt16 ports to [UInt8]
        let dataPortUInt8: [UInt8] = convertUInt16ToUInt8(dataPort)
        let videoPortUInt8: [UInt8] = convertUInt16ToUInt8(videoPort)
        
        var buffer: [UInt8] = dataPortUInt8 + videoPortUInt8 //concatenates booth ports
        buffer.insert(20, atIndex: 0) //adds the ID for handshake
        
        sendStream(buffer)
        
        debugPrint("sent handshake dataPort: \(dataPort), videoPort: \(videoPort)")
    }
    
    //sends the given byteArray via UDP to the car
    func sendStream(byteArray: [UInt8]){
        let data: NSData = NSData(bytes: byteArray as [UInt8], length: byteArray.count)
        udpSocket.sendData(data, withTimeout: 2, tag: 0)
    }
}