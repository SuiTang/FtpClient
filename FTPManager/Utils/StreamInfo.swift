//
//  StreamInfo.swift
//  FtpClient
//
//  Created by damingdan on 15/4/9.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

/// default buffer size
let DefaultBufferSize = 32768

class StreamInfo: NSObject {
    var writeStream:NSOutputStream!
    
    var readStream:NSInputStream!
    
    var bytesThisIteration:Int = 0
    var bytesTotal:Int = 0
    var timeout:Int = 0
    var cancelRequestFlag:Bool = false
    var cancelDoesNotCallDelegate:Bool = false
    
    
    func openRead(request:RequestProtocol) {
    }
    
    func openWrite(request:RequestProtocol) {
    }
    
    func checkCancelRequest(request:RequestProtocol)->Bool {
        return false
    }
    
    func read(request:RequestProtocol)->NSData {
        return NSData()
    }
    
    func write(request:RequestProtocol, data:NSData) {
    }
}
