//
//  ListingRequest.swift
//  FtpClient
//
//  Created by damingdan on 15/4/10.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

class ListingRequest: Request {
    var filesInfo:[NSDictionary] = []
    var receivedData:NSMutableData = NSMutableData()
    
    override func start() {
        self.maximumSize = Float(LONG_MAX)
        
        // open the read stream and check for errors calling delegate methods
        // if things fail. This encapsulates the streamInfo object and cleans up our code.
        self.streamInfo.openRead(self)
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        var data:NSData = NSData();
        switch eventCode {
        case NSStreamEvent.OpenCompleted:
            filesInfo = []
            didOpenStream = true
            break
        case NSStreamEvent.HasBytesAvailable:
            if let data = self.streamInfo.read(self) {
                receivedData.appendData(data)
            }else {
                self.streamInfo.streamError(self, errorCode: FTPErrorCode.ClientCantReadStream)
            }
            break
        case NSStreamEvent.HasSpaceAvailable:break
        case NSStreamEvent.ErrorOccurred:
            self.streamInfo.streamError(self, errorCode: FTPError.errorCodeWithError(aStream.streamError!))
            break
        case NSStreamEvent.EndEncountered:
            parseData()
            self.streamInfo.streamComplete(self)
            break
        default:
            break
        }
    }
    
    func parseData() {
        var bytes = UnsafePointer<UInt8>(receivedData.bytes)
        var offset = 0
        var totalbytes = receivedData.length
        var parsedBytes:CFIndex
        
        do {
            var listingEntity:Unmanaged<CFDictionary>?
            parsedBytes = CFFTPCreateParsedResourceListing(nil, bytes, totalbytes - offset, &listingEntity)
            if parsedBytes > 0 {
                if let entity = listingEntity {
                    filesInfo.append(entity.takeUnretainedValue())
                }
                offset += parsedBytes
            }
        } while totalbytes > 0
    }
}
