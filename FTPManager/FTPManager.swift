//
//  FTPManager.swift
//  FtpClient
//
//  Created by ZhouZeyong on 15/4/7.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit
import CFNetwork

@objc protocol FTPManagerDelegate : NSObjectProtocol {
    /**
    When file uploaded, this method will be called
    
    :param: success If upload success, It will be true
    */
    func ftpUploadFinishedWithSuccess(success:Bool);
    
    /**
    When file downloaded, this method will be called
    
    :param: success If download success, It will be true
    */
    func ftpDownloadFinishedWithSuccess(success:Bool);
    
    /**
    When directory listed, this method will be called
    
    :param: success If list success, It will be true
    */
    func directoryListingFinishedWithSuccess(success:Bool);
    
    /**
    Fetch error
    
    :param: err error description
    */
    func ftpError(err:String);
}

class FTPManager: NSObject {
    private var server:String!
    
    private var username:String!
    
    private var password:String!
    
    init(server:String, username:String, password:String) {
        super.init();
        self.server = server;
        self.username = username;
        self.password = password;
    }
    
    func downloadRemoteFile(filename:String, localname:String) {
    }
    
    func uploadFileWithFilePath(filePath:String) {
    }
    
    func createRemoteDirectory(dirname:String) {
    }
    
    func listRemoteDirectory() {
    }
    
    func scheduleInCurrentThread(stream:NSStream) {
        stream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    
}
