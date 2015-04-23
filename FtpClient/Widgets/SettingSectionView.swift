//
//  SettingSectionView.swift
//  FtpClient
//
//  Created by damingdan on 15/4/23.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit
import Snap

class SettingSectionView: UIView {
    var titleLabel:UILabel = UILabel()
    
    var contentView:UIView? {
        didSet {
            addSubview(self.contentView!)
            self.contentView?.snp_makeConstraints({ (make) -> Void in
                make.left.equalTo(self.titleLabel.snp_trailing).offset(self.contentInsets.left)
                make.top.equalTo(self).offset(self.contentInsets.top)
                make.bottom.equalTo(self).offset(self.contentInsets.bottom)
                make.right.equalTo(self).offset(self.contentInsets.right)
            })
        }
    }
    
    var contentInsets:UIEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    var labelWidth:CGFloat = 80 {
        didSet {
            titleLabel.snp_remakeConstraints { (make) -> Void in
                make.left.equalTo(self)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
                make.width.equalTo(self.labelWidth)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSettingSectionView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSettingSectionView()
    }
    
    func setupSettingSectionView() {
        backgroundColor = UIColor.whiteColor()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.font = UIFont.systemFontOfSize(14)
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(self.labelWidth)
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        var linePath = UIBezierPath()
        var startPoint = CGPointMake(rect.x, rect.y + rect.height)
        var endPoint = CGPointMake(rect.x + rect.width, rect.y + rect.height)
        linePath.moveToPoint(startPoint)
        linePath.addLineToPoint(endPoint)
        UIColor.lightGrayColor().setStroke()
        linePath.stroke()
    }
    

}
