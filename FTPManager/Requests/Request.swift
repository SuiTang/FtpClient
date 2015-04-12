//
//  Request.swift
//  FtpClient
//
//  Created by damingdan on 15/4/9.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit


let ftpPrefix = "ftp://";

@objc protocol RequestProtocol : NSObjectProtocol {
    var passiveMode:Bool {get set}
    var uuid:String{get set}
    
    var path:String{get set}
    var error:FTPError?{get set}
    var streamInfo:StreamInfo{get set}
    
    var maximumSize:Float{get set}
    var percentCompleted:Float{get set}
    
    /**
    Return a full ftp url like ftp://yourdomain.com/path by given svn.kingoit.com.
    The 'root/foo' is the path by setting the proprty self.path.
    the url is given by reqest data source
    
    :returns: full ftp url
    */
    func fullUrl()->NSURL?
    
    /**
    Return a full ftp url like ftp://username:password@yourdomain.com/path by given hostname,
    username and password etc. this param given by data source
    
    :returns: full ftp url
    */
    func fullURLWithEscape()->NSURL?
    
    func start()
    
    func cancelRequest()
}


@objc protocol DataExchangeRequestProtocol : RequestProtocol {
    var localFilePath:String {get set}
    var fullRemotePath:String {get set}
}

@objc protocol RequestDelegate:NSObjectProtocol {
    func requestCompleted(request: RequestProtocol)
    
    func requestFailed(request:RequestProtocol)
    
    optional func percentCompleted(percent:Float, request:RequestProtocol)
    
    optional func dataAvailable(data:NSData, request:DataExchangeRequestProtocol)
    
    optional func shouldOverwriteFile(filePath:String, request:DataExchangeRequestProtocol)
}

@objc protocol RequestDataSource : NSObjectProtocol {
    func hostnameForRequest(request:RequestProtocol)->String
    
    func usernameForReqeust(request:RequestProtocol)->String
    
    func passwordForRequest(request:RequestProtocol)->String
    
    optional func dataSizeForUploadRequest(request:DataExchangeRequestProtocol)->Int
    
    optional func dataForUploadRequest(request:DataExchangeRequestProtocol)->NSData
}




/**
*  ftp request
*/
class Request:NSObject, NSStreamDelegate, RequestProtocol {
    /// Report the request state
    var delegate:RequestDelegate
    
    /// Provide the host name, user name, password etc.
    var dataSource:RequestDataSource
    
    var passiveMode:Bool = true
    var uuid:String = NSUUID().UUIDString
    
    /// The request path, when request the ftp server, this is the directory at server
    var path:String {
        get {
            // we remove all the extra slashes from the directory path, including the last one (if there is one)
            // we also escape it
            var escapedPath = self.path.stringByStandardizingPath;
            
            if !(escapedPath as NSString).absolutePath {
                escapedPath = "/\(escapedPath)";
            }
            return urlEncode(escapedPath)!;
        }
        
        set {
            self.path = newValue;
        }
    }
    
    var error:FTPError?
    var streamInfo:StreamInfo = StreamInfo()
    
    var maximumSize:Float = 0
    var percentCompleted:Float = 0
    
    /// will have bytes from the last FTP call
    var bytesSent:Int {
        get {
            return self.streamInfo.bytesThisIteration;
        }
    }
    
    /// will have bytes total sent
    var totalBytesSent:Int {
        get {
            return self.streamInfo.bytesTotal;
        }
    }
    
    var timeout:Int64 {
        get {
            return self.streamInfo.timeout;
        }
        
        set  {
            self.streamInfo.timeout = newValue;
        }
    }
    
    /// whether the stream opened or not
    var didOpenStream:Bool = false
    
    /// cancel closes stream without calling delegate
    var cancelDoesNotCallDelegate:Bool {
        get {
            return self.streamInfo.cancelDoesNotCallDelegate;
        }
        
        set {
            self.streamInfo.cancelDoesNotCallDelegate = newValue;
        }
    }
    
    init(delegate:RequestDelegate, dataSource:RequestDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
        super.init()
    }
    
    /**
    Return a full ftp url like ftp://yourdomain.com/path by given svn.kingoit.com.
    The 'root/foo' is the path by setting the proprty self.path.
    the url is given by reqest data source
    
    :returns: full ftp url
    */
    func fullUrl() -> NSURL? {
        var hostname = dataSource.hostnameForRequest(self);
        // Check is the given url's prev 6 is 'ftp://'
        var length = hostname.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if  length >= 6 && hostname.substring(0, length: 6) == ftpPrefix {
            hostname = hostname.substring(6);
        }
        var path = self.path.hasPrefix("/") ? self.path.substring(1):self.path;
        var fullUrlString = "\(ftpPrefix)\(hostname)/\(path)";
        return NSURL(string: fullUrlString);
    }
    
    /**
    Return a full ftp url like ftp://username:password@yourdomain.com/path by given hostname,
    username and password etc. this param given by data source
    
    :returns: full ftp url
    */
    func fullURLWithEscape() -> NSURL? {
        var escapedUsername = urlEncode(dataSource.usernameForReqeust(self));
        var escapedPassword = urlEncode(dataSource.passwordForRequest(self));
        var cred = "";
        if let username = escapedUsername {
            if let password = escapedPassword {
                cred = "\(username):\(password)@";
            }else {
                cred = "\(username)@";
            }
        }
        cred = cred.stringByStandardizingPath;
        
        var hostname = dataSource.hostnameForRequest(self);
        // Check is the given url's prev 6 is 'ftp://'
        var length = hostname.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if  length >= 6 && hostname.substring(0, length: 6) == ftpPrefix {
            hostname = hostname.substring(6);
        }
        var path = self.path.hasPrefix("/") ? self.path.substring(1):self.path;
        var fullUrlString = "\(ftpPrefix)\(cred)\(hostname)/\(path)";
        return NSURL(string: fullUrlString);
    }
    
    /**
    create url encoding string
    http://stackoverflow.com/questions/25786226/why-doesnt-cfstringencodings-have-utf8-in-swift/25786651#25786651
    
    :param: string url to encode
    
    :returns: encoded string
    */
    func urlEncode(string:String)->String? {
        /*
        In the object style, you can write this like this
        var urlEncoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, string, nil, "/!*'\"();:@&=+$,?%#[]% ", CFStringBuiltInEncodings.UTF8.rawValue);
        return urlEncoded as String;
        */
        let charset = NSCharacterSet(charactersInString: "!*'\"();:@&=+$,?%#[]% ").invertedSet;
        return string.stringByAddingPercentEncodingWithAllowedCharacters(charset);
    }
    
    func start() {
        // override in sub class
    }
    
    func cancelRequest() {
        self.streamInfo.cancelRequestFlag = true;
    }
}
