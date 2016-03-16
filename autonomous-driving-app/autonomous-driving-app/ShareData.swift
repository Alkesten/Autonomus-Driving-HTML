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
    let carPort: UInt16 = 3030
    let dataPort: UInt16 = 3040
    let videoPort: UInt16 = 3050
}
