//
//  RootNavigationController.swift
//  FtpClient
//
//  Created by damingdan on 15/4/22.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
}
