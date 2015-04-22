//
//  RequestTest.swift
//  FtpClient
//
//  Created by damingdan on 15/4/10.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit
import XCTest

class RequestTest: XCTestCase, RequestDelegate, RequestDataSource {
    var request:ListingRequest!
    
    var hostname = "svn.kingoit.com"
    
    var username = "zhouzeyong"
    
    var password = "240383"

    override func setUp() {
        super.setUp()
        self.request = ListingRequest(delegate: self, dataSource: self);
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFullUrl() {
        self.request.path = "/root/path";
        if let url = self.request.fullUrl() {
            XCTAssertEqual(url, NSURL(string: "ftp://svn.kingoit.com/root/path")!, "Equal is pass");
        }else {
            XCTAssert(false, "not pass")
        }
        
        request.path = "foo";
        if let url = self.request.fullUrl() {
            XCTAssertEqual(url, NSURL(string:"ftp://svn.kingoit.com/foo")!, "Equal is pass");
        }else {
            XCTAssert(false, "not pass")
        }
        
        hostname = "ftp://svn.kingoit.com";
        if let url = self.request.fullUrl() {
            XCTAssertEqual(url, NSURL(string:"ftp://svn.kingoit.com/foo")!, "Equal is pass");
        }else {
            XCTAssert(false, "not pass")
        }
    }
    
    func testurlEncode() {
        let testString = "wwww.bravedefault/(&[])/sdkjhfs3434/&@";
        if let encodedStr = request.urlEncode(testString) {
            XCTAssertEqual(encodedStr, "wwww.bravedefault%2F%28%26%5B%5D%29%2Fsdkjhfs3434%2F%26%40", "url encode");
        }else {
            XCTAssert(false, "not pass")
        }
    }
    
    func testFullURLWithEscape() {
        self.request.path = "/root/path";
        if let url = self.request.fullURLWithEscape() {
            XCTAssertEqual(url, NSURL(string: "ftp://zhouzeyong:240383@svn.kingoit.com/root/path")!, "Equal is pass");
        }else {
             XCTAssert(false, "not pass")
        }
    }
    
    func testListingRequest() {
        request.start()
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
