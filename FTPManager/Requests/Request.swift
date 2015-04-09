//
//  Request.swift
//  FtpClient
//
//  Created by damingdan on 15/4/9.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit


@objc protocol RequestProtocol {
    var passiveMode:Bool {get set}
    var uuid:String{get set}
    
    var path:String{get set}
    var error:FTPError{get set}
}

class Request: NSObject {
   
}
