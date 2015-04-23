//
//  ViewController.swift
//  FtpClient
//
//  Created by ZhouZeyong on 15/4/7.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(sender: AnyObject) {
        if let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FTPLoginViewController") as? UIViewController {
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
}

