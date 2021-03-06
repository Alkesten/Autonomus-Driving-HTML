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
    
    var video: Video
    
    override init(localPort: UInt16) {
        video = Video()
        super.init(localPort: localPort)
        setupConnection()
        print("new VideoSocket created")
    }
    
    //binds the VideoSocket to the port and starts receiving
    func setupConnection(){
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        do {
            try udpSocket.bindToPort(localPort) //binds the socket to the local port
                //no need of connection to the car since data will be send via DataSocket
            try udpSocket.beginReceiving() //starts receiving
        } catch let err as NSError {
            err.description
        }
        debugPrint("VideoSocket \(self) bound to \(localPort) with car \(shared.car.ipv4):\(shared.car.port)")
        super.sendString("VideoSocketEstablished")
    }
    
    /*
    CocoaAsyncSocket Framework function
    http://cocoadocs.org/docsets/CocoaAsyncSocket/7.4.1/
    */
    override func udpSocket(sock : GCDAsyncUdpSocket!, didReceiveData data : NSData!,  fromAddress address : NSData!,  withFilterContext filterContext : AnyObject!) {
        print("Received: \(data)")
        do {
            let payload = try extractByte(data)
            video.processRxVideo(payload)
        } catch let err as NSError {
            err.description
        }
    }
    
    /*
      when calling function:
      do {
        extractByte(data)
      } catch VideoError.NonVideoData {
        print("Received non video data on video port")
      }
    */
    func extractByte(data: NSData) throws -> [UInt8]{
        let pointer = UnsafePointer<UInt8>(data.bytes)
        let count = data.length
        
        let buffer = UnsafeBufferPointer<UInt8>(start:pointer, count:count)
        let array = [UInt8](buffer)
        var payload = array
        payload.removeFirst()
        
        let id: UInt8 = buffer[0]
        
        guard id == 14 else {
            throw VideoError.NonVideoData
        }

        return payload
    }
}

enum VideoError : ErrorType {
    case NonVideoData
}
