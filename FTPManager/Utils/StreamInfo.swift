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
    var writeStream:NSOutputStream?
    
    var readStream:NSInputStream?
    
    var bytesThisIteration:Int = 0
    var bytesTotal:Int = 0
    var timeout:Int64 = 30
    var cancelRequestFlag:Bool = false
    var cancelDoesNotCallDelegate:Bool = false
    
    var queue:dispatch_queue_t = dispatch_queue_create("com.albertodebortoli.goldraccoon.streaminfo", DISPATCH_QUEUE_CONCURRENT)
    
    
    func openRead(request:Request) {
        // make sure the host name is not null
        let hostname = request.dataSource.hostnameForRequest(request)
        if hostname.isEmpty {
            request.error = FTPError(errorCode: FTPErrorCode.ClientHostnameIsNil);
            request.delegate.requestFailed(request);
            request.streamInfo.close(request);
            return;
        }
        
        var readStreamRef = CFReadStreamCreateWithFTPURL(nil, request.fullUrl()!).takeRetainedValue();
        CFReadStreamSetProperty(readStreamRef, kCFStreamPropertyFTPAttemptPersistentConnection, kCFBooleanFalse);
        CFReadStreamSetProperty(readStreamRef, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFReadStreamSetProperty(readStreamRef, kCFStreamPropertyFTPUsePassiveMode, request.passiveMode ? kCFBooleanTrue :kCFBooleanFalse);
        CFReadStreamSetProperty(readStreamRef, kCFStreamPropertyFTPFetchResourceInfo, kCFBooleanTrue);
        CFReadStreamSetProperty(readStreamRef, kCFStreamPropertyFTPUserName, request.dataSource.usernameForReqeust(request));
        CFReadStreamSetProperty(readStreamRef, kCFStreamPropertyFTPPassword, request.dataSource.passwordForRequest(request));
        self.readStream = readStreamRef;
        
        if let rs = self.readStream {
            rs.delegate = request;
            rs.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode);
            rs.open();
            
            request.didOpenStream = false;
            var t:Int64 = timeout*Int64(NSEC_PER_SEC);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, t), queue, { () -> Void in
                if !request.didOpenStream && request.error == nil {
                    request.error = FTPError(errorCode: FTPErrorCode.ClientStreamTimedOut);
                    request.delegate.requestFailed(request);
                    request.streamInfo.close(request);
                }
            });
        }else {
            request.error = FTPError(errorCode: FTPErrorCode.ClientCantReadStream);
            request.delegate.requestFailed(request);
            request.streamInfo.close(request);
            return;
        }
    }
    
    func openWrite(request:Request) {
        // make sure the host name is not null
        let hostname = request.dataSource.hostnameForRequest(request)
        if hostname.isEmpty {
            request.error = FTPError(errorCode: FTPErrorCode.ClientHostnameIsNil);
            request.delegate.requestFailed(request);
            request.streamInfo.close(request);
            return;
        }
        
        var writeStreamRef = CFWriteStreamCreateWithFTPURL(nil, request.fullUrl()).takeRetainedValue();
        CFWriteStreamSetProperty(writeStreamRef, kCFStreamPropertyFTPAttemptPersistentConnection,kCFBooleanFalse);
        
        CFWriteStreamSetProperty(writeStreamRef, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStreamRef, kCFStreamPropertyFTPUsePassiveMode, request.passiveMode ? kCFBooleanTrue :kCFBooleanFalse);
        CFWriteStreamSetProperty(writeStreamRef, kCFStreamPropertyFTPFetchResourceInfo, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStreamRef, kCFStreamPropertyFTPUserName, request.dataSource.usernameForReqeust(request));
        CFWriteStreamSetProperty(writeStreamRef, kCFStreamPropertyFTPPassword, request.dataSource.passwordForRequest(request));
        self.writeStream = writeStreamRef;
        
        if let ws = self.writeStream {
            ws.delegate = request;
            ws.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode);
            ws.open();
            
            request.didOpenStream = false;
            var t:Int64 = timeout*Int64(NSEC_PER_SEC);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, t), queue, { () -> Void in
                if !request.didOpenStream && request.error == nil {
                    request.error = FTPError(errorCode: FTPErrorCode.ClientStreamTimedOut);
                    request.delegate.requestFailed(request);
                    request.streamInfo.close(request);
                }
            });
        }else {
            request.error = FTPError(errorCode: FTPErrorCode.ClientCantReadStream);
            request.delegate.requestFailed(request);
            request.streamInfo.close(request);
            return;
        }
    }
    
    func checkCancelRequest(request:Request)->Bool {
        if !cancelRequestFlag {
            return false;
        }
        
        if !cancelDoesNotCallDelegate {
            request.delegate.requestCompleted(request);
        }
        
        request.streamInfo.close(request);
        return true;
    }
    
    func read(request:Request)->NSData? {
        var data:NSData;
        var buffer = [UInt8](count:DefaultBufferSize, repeatedValue: 0)
        
        bytesThisIteration = readStream!.read(&buffer, maxLength: DefaultBufferSize);
        self.bytesTotal += bytesThisIteration;
        
        if bytesThisIteration > 0 {
            data = NSData(bytes: buffer, length: bytesThisIteration);
            request.percentCompleted = Float(bytesTotal)/request.maximumSize;
            request.delegate.percentCompleted?(request.percentCompleted, request: request);
            return data;
        }else if bytesThisIteration == 0 {
            // return no data, but this isn't an error... just the end of the file
            return NSData();
        }
        
        // otherwise we had an error, return an error
        self.streamError(request, errorCode: FTPErrorCode.ClientCantReadStream);
        return nil;
    }
    
    func write(request:Request, data:NSData)->Bool {
        var bytes = UnsafePointer<UInt8>(data.bytes)
        var length: NSInteger = data.length
        bytesThisIteration = self.writeStream!.write(bytes, maxLength: length);
        bytesTotal += bytesThisIteration;
        
        if bytesThisIteration > 0 {
            request.percentCompleted = Float(bytesTotal)/request.maximumSize;
            request.delegate.percentCompleted?(request.percentCompleted, request: request);
            return true;
        }else if bytesThisIteration == 0 {
            return true;
        }
        
        self.streamError(request, errorCode: FTPErrorCode.ClientCantWriteStream)
        return false
    }
    
    func streamError(request:Request, errorCode:FTPErrorCode) {
        request.error = FTPError(errorCode: errorCode)
        request.delegate.requestFailed(request)
        request.streamInfo.close(request)
    }
    
    func streamComplete(request:Request) {
        request.delegate.requestCompleted(request)
        request.streamInfo.close(request)
    }
    
    func close(request:RequestProtocol) {
        if readStream != nil {
            readStream!.close()
            readStream!.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            readStream = nil
        }
        
        if writeStream != nil {
            writeStream!.close()
            writeStream!.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            writeStream = nil
        }
    }
}
