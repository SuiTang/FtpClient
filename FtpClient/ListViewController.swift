//
//  ListViewController.swift
//  FtpClient
//
//  Created by damingdan on 15/4/23.
//  Copyright (c) 2015年 ZhouZeyong. All rights reserved.
//

import UIKit
import Snap

let ListCellIdentifier = "ListCell"

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshView:RefreshView = RefreshView(frame: CGRectZero);
    
    var manager:FTPManager = FTPManager()
    
    var server:FMServer!
    
    var files:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Add the ansyic task indicator
        self.view.addSubview(refreshView)
        var topX:CGFloat = 0
        if let navigationBar = self.navigationController?.navigationBar {
            topX = navigationBar.bounds.height
        }
        refreshView.snp_makeConstraints { (make) -> Void in
            var topLayoutGuide = self.topLayoutGuide as! UIView
            make.top.equalTo(topLayoutGuide.snp_bottom).offset(topX)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(3)
        }
        
        
        //Load the content
        var loadListQueue = dispatch_queue_create("Load List Queue", nil)
        refreshView.startRefresh()
        dispatch_async(loadListQueue, { () -> Void in
            self.files = self.manager.contentsOfServer(self.server)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.refreshView.finishRefresh()
                self.tableView.reloadData()
            })
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(ListCellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ListCellIdentifier)
        }
        if let dic = self.files[indexPath.row] as? NSDictionary {
            cell?.textLabel?.text = dic.objectForKey(kCFFTPResourceName) as? String
        }
        
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
