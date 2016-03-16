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
    
    override init(car: Car, localPort: UInt16) {
        video = Video()
        super.init(car: car, localPort: localPort)
        setupConnection()
        print("new VideoSocket created")
    }

    func setupConnection(){
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do {
            try udpSocket.bindToPort(localPort)
            try udpSocket.beginReceiving()
        } catch let err as NSError {
            err.description
        }
        super.sendString("VideoSocketEstablished")
    }
    
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
