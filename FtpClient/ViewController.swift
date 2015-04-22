//
//  ViewController.swift
//  FtpClient
//
//  Created by ZhouZeyong on 15/4/7.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RequestDelegate, RequestDataSource {
    var request:ListingRequest!
    
    var hostname = "svn.kingoit.com"
    
    var username = "zhouzeyong"
    
    var password = "240383"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        request = ListingRequest(delegate: self, dataSource: self)
        request.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func hostnameForRequest(request: RequestProtocol) -> String {
        return hostname;
    }
    
    func passwordForRequest(request: RequestProtocol) -> String {
        return password;
    }
    
    func usernameForReqeust(request: RequestProtocol) -> String {
        return username;
    }
    
    func requestCompleted(request: RequestProtocol) {
        if let listingRquest = request as? ListingRequest {
            for dic in listingRquest.filesInfo {
                var name = dic.valueForKey(kCFFTPResourceName as String) as? String
                println(name)
            }
        }
    }
    
    func requestFailed(request: RequestProtocol) {
        println(request.error?.description)
    }

}

