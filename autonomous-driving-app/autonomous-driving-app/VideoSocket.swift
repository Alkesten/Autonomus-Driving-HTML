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
    
    //var video: Video
    
    override init(car: Car, localPort: UInt16) {
        super.init(car: car, localPort: localPort)
        //self.video = Video()
        setupConnection()
    }
    
    func setupConnection(){
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do {
            try udpSocket.bindToPort(localPort)
        } catch let err as NSError {
            err.description
        }
        do {
            try udpSocket.beginReceiving()
        } catch let err as NSError {
            err.description
        }
        super.sendString("VideoSocketEstablished")
    }
    
    
}