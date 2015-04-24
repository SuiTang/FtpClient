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

class ListTableViewCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var fileTypeImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var detailImageView:UIImageView!
    
    func configCell(fileInfo:NSDictionary) {
        var fileName = ""
        if let name = fileInfo.objectForKey(kCFFTPResourceName) as? String {
            titleLabel.text = name
            fileName = name
        }
        
        var createDate = NSDate()
        var fileSize:Float = 0
        if let date = fileInfo.objectForKey(kCFFTPResourceModDate) as? NSDate {
            createDate = date
        }
        
        if let size = fileInfo.objectForKey(kCFFTPResourceSize) as? Float {
            fileSize = size
        }
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM dd, yyyy, HH:mm:ss"
        var createDateStr = formatter.stringFromDate(createDate)
        descriptionLabel.text = "\(createDateStr)  \(fileSize)"
        
        if let type = fileInfo.objectForKey(kCFFTPResourceType) as? NSNumber {
            if type.intValue == DT_DIR {
                self.fileTypeImageView.image = UIImage(named: "folder")
                self.detailImageView.hidden = false
            }else if type.intValue == DT_REG {
                var fileExtension = fileName.pathExtension
                self.fileTypeImageView.image = FileTypeManager(fileExtension: fileExtension).image
                self.detailImageView.hidden = true
            }else {
                self.detailImageView.hidden = true
            }
        }else {
            self.fileTypeImageView.image = UIImage(named: "blank")
            self.detailImageView.hidden = true
        }
    }
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshView:RefreshView = RefreshView(frame: CGRectZero);
    
    var manager:FTPManager = FTPManager()
    
    var server:FMServer!
    
    var files:[AnyObject] = [] {
        didSet {
            // Remove . and ..
            for var i = 0; i<self.files.count; i++ {
                var fileInfo = self.files[i] as? NSDictionary
                if let name = fileInfo?.objectForKey(kCFFTPResourceName) as? String {
                    if name == "." || name == ".." {
                        self.files.removeAtIndex(i)
                    }
                }
            }
        }
    }
    
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
        var cell = tableView.dequeueReusableCellWithIdentifier(ListCellIdentifier) as? ListTableViewCell
        
        if let dic = self.files[indexPath.row] as? NSDictionary {
            cell?.configCell(dic)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let name = self.files[indexPath.row].objectForKey(kCFFTPResourceName) as? String {
            if let listViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ListViewController") as? ListViewController {
                //self.navigationController?.pushViewController(listViewController, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
