//
//  FTPError.swift
//  FtpClient
//
//  Created by damingdan on 15/4/9.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit


enum FTPErrorCode:Int {
    //client errors
    case ClientHostnameIsNil = 901
    case ClientCantOpenStream = 902
    case ClientCantWriteStream = 903
    case ClientCantReadStream = 904
    case ClientSentDataIsNil = 905
    case ClientFileAlreadyExists = 907
    case ClientCantOverwriteDirectory = 908
    case ClientStreamTimedOut = 909
    case ClientCantDeleteFileOrDirectory = 910
    case ClientMissingRequestDataAvailable = 911
    
    // 400 FTP errors
    case ServerAbortedTransfer = 426
    case ServerResourceBusy = 450
    case ServerCantOpenDataConnection = 425
    
    // 500 FTP errors
    case ServerUserNotLoggedIn = 530
    case ServerFileNotAvailable = 550
    case ServerStorageAllocationExceeded = 552
    case ServerIllegalFileName = 553
    case ServerUnknownError
    
    case UnknownError
}

/**
*  FTP Manager's error define, TODO: bind the error message and error code
*/
class FTPError:NSObject {
    var errorCode:FTPErrorCode = FTPErrorCode.UnknownError
    
    var message:String {
        get {
            switch (self.errorCode) {
                // Client errors
            case FTPErrorCode.ClientSentDataIsNil:
                return "Data is nil.";
                
                
            case FTPErrorCode.ClientCantOpenStream:
                return "Unable to open stream.";
                
                
            case FTPErrorCode.ClientCantWriteStream:
                return "Unable to write to open stream.";
                
                
            case FTPErrorCode.ClientCantReadStream:
                return "Unable to read from open stream.";
                
                
            case FTPErrorCode.ClientHostnameIsNil:
                return "Hostname is nil.";
                
                
            case FTPErrorCode.ClientFileAlreadyExists:
                return "File already exists!";
                
                
            case FTPErrorCode.ClientCantOverwriteDirectory:
                return "Can't overwrite directory!";
                
                
            case FTPErrorCode.ClientStreamTimedOut:
                return "Stream timed out with no response from server.";
                
                
            case FTPErrorCode.ClientCantDeleteFileOrDirectory:
                return "Can't delete file or directory.";
                
                
            case FTPErrorCode.ClientMissingRequestDataAvailable:
                return "Delegate missing dataAvailable:forRequest:";
                
                
                // Server errors
            case FTPErrorCode.ServerAbortedTransfer:
                return "Server aborted transfer.";
                
                
            case FTPErrorCode.ServerResourceBusy:
                return "Resource is busy.";
                
                
            case FTPErrorCode.ServerCantOpenDataConnection:
                return "Server can't open data connection.";
                
                
            case FTPErrorCode.ServerUserNotLoggedIn:
                return "Not logged in.";
                
                
            case FTPErrorCode.ServerStorageAllocationExceeded:
                return "Server allocation exceeded!";
                
                
            case FTPErrorCode.ServerIllegalFileName:
                return "Illegal file name.";
                
                
            case FTPErrorCode.ServerFileNotAvailable:
                return "File or directory not available or directory already exists.";
                
                
            case FTPErrorCode.ServerUnknownError:
                return "Unknown FTP error!";
                
                
            default:
                return "Unknown error!";
                
            }
        }
    }
    
    static func errorCodeWithError(error:NSError)->FTPErrorCode {
        var userInfo = error.userInfo;
        var code: AnyObject? = userInfo?[kCFFTPStatusCodeKey];
        if let c: AnyObject = code {
            return FTPErrorCode(rawValue: c.integerValue)!
        }
        return FTPErrorCode.UnknownError
    }
}