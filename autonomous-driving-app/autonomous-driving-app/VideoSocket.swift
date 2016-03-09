//
//  VideoSocket.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 09.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class VideoSocket: Socket {
    
    override init(car: Car, localPort: UInt16) {
        super.init(car: car, localPort: localPort)
    }
    
    func setupConnection(){
        var error : NSError?
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        udpSocket.bindToPort(localPort, error: &error)
        udpSocket.beginReceiving(&error)
        super.sendString("VideoSocketEstablished")
    }
}