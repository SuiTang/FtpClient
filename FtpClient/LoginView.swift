//
//  LoginView.swift
//  FtpClient
//
//  Created by damingdan on 15/4/23.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

/**
*  All the login view's super view.
*/
class LoginView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLoginView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoginView()
    }
    
    func setupLoginView() {
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
