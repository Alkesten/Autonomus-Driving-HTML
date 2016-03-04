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
    
    var LPORT: UInt16
    var RPORT: UInt16
    var SERVER_IP: String?
    var socket: GCDAsyncUdpSocket?
    
    init(SERVER_IP: String?, RPORT: UInt16)
    {
        if SERVER_IP {
            self.SERVER_IP = SERVER_IP!
        }
        self.RPORT = RPORT
        
        println("Socket created with host: \(self.SERVER_IP) and port: \(self.RPORT).")
    }
    
    convenience init(RPORT:UInt16) {
        self.init(SERVER_IP: nil, RPORT: RPORT)
    }
    
    func setupConnection(){
        var error : NSError?
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        socket.bindToPort(LPORT, error: &error)
        socket.connectToHost(SERVER_IP, onPort: RPORT, error: &error)
        socket.beginReceiving(&error)
        sendString("HelloCar")
    }
    
    func stopServer() -> Bool
    {
        if socket
        {
            socket!.disconnect()
            return true
        }
        return false
    }
    
    func sendString(message:string){
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        socket.sendData(data, withTimeout: 2, tag: 0)
    }
    
    func sendStream(bytes: [UInt8]){
        socket.sendData(bytes, withTimeout: 2, tag: 0)
    }
    

}
