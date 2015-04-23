//
//  RefreshView.swift
//  FtpClient
//
//  Created by damingdan on 15/4/23.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    var isRefreshing:Bool = false
    
    var progressColor:UIColor = UIColor(red: 22/CGFloat(255.0), green: 126/CGFloat(255.0), blue: 251/CGFloat(255.0), alpha: CGFloat(1.0))
    
    private var refreshBarView:UIView = UIView()
    
    private var refreshIndicators:[UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRefreshView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRefreshView()
    }
    
    func setupRefreshView() {
        refreshBarView.frame = CGRectMake(0, 0, 0, self.frame.width)
        backgroundColor = UIColor.clearColor()
    }
    
    func setRefreshBarProgress(progress:CGFloat) {
        refreshBarView.backgroundColor = progressColor
        var barFrame = self.refreshBarView.frame
        var x = (self.frame.width - progress)/2
        barFrame.size.width = progress
        barFrame.x = x
        self.refreshBarView.frame = barFrame
    }
    
    func isProgressFull()-> Bool {
        var width = refreshBarView.frame.width
        return width > self.frame.width
    }
    
    func startRefresh() {
        isRefreshing = true
        setRefreshBarProgress(0)
        
        for i in 0...2 {
            var indicator = UIView(frame: CGRectMake(0, 0, self.frame.height, self.frame.height))
            indicator.backgroundColor = UIColor.whiteColor()
            
            var delay = 0.4*i
            UIView.animateWithDuration(1.2, delay: delay, options: UIViewAnimationOptions.CurveEaseIn|UIViewAnimationOptions.Repeat, animations: { () -> Void in
                var frame = indicator.frame
                frame.x = self.frame.width
                indicator.frame = frame
            }, completion: { (Bool) -> Void in
                
            })
            self.addSubview(indicator)
            refreshIndicators.append(indicator)
        }
        
        self.backgroundColor = progressColor
    }
    
    func finishRefresh() {
        isRefreshing = false
        
        backgroundColor = UIColor.clearColor()
        for view in refreshIndicators {
            view.removeFromSuperview()
        }
        refreshIndicators.removeAll(keepCapacity: false)
    }

}
