//
//  ShareData.swift
//  autonomous-driving-app
//
//  Created by Moritz Kellermann on 16.03.16.
//  Copyright © 2016 Kirsten Rauffer. All rights reserved.
//

import Foundation

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }
    
    var car : Car!
    var remoteControl: RemoteControl!
    var dataSocket: DataSocket!
    var videoSocket: VideoSocket!
    
    /*
    creates the car, datasocket, videosocket, remotecontrol and sends the handshake
    Must called once only!
    */
    func ini(ipv4: String, carPort: UInt16, dataPort: UInt16, videoPort: UInt16) -> Bool{
        self.car = Car.init(ipv4: ipv4, port: carPort)
        self.dataSocket = DataSocket(localPort: dataPort)
        self.videoSocket = VideoSocket(localPort: videoPort)
        
        self.dataSocket.handshake(self.videoSocket.localPort, dataPort: self.dataSocket.localPort)
        self.remoteControl = RemoteControl()
        
        return true
    }
}
