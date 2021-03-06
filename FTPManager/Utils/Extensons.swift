//
//  ViewController+Extension.swift
//  MobileMap
//
//  Created by damingdan on 15/2/7.
//  Copyright (c) 2015年 Kingoit. All rights reserved.
//

import UIKit

extension UIDevice {
    public class func systemVersionFloatValue()->Float {
        return (UIDevice.currentDevice().systemVersion as NSString).floatValue;
    }
}

extension CGRect {
    var x:CGFloat {
        get {
            return origin.x;
        }
        set {
            origin.x = newValue;
        }
    }
    
    var y:CGFloat {
        get {
            return origin.y;
        }
        set {
            origin.y = newValue;
        }
    }
}

extension UIViewController {
    
    /**
    Add the keyboard notification to current view that when keyboard showing, the view will shift to make the first responder view can be seen.
    */
    public func bindKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil);
    }
    
    /**
    When the keyboard show, make the view shit so that the responder text field can be seen. IOS7 and IOS8 have some diffirent in rect of the views at diffirent orientation.
    
    :param: notification
    */
    func keyboardWillShow(notification:NSNotification) {
        var firstResponder = self.view.findFirstResponderView();
        if firstResponder == nil {
            return;
        }
        if !firstResponder!.isKindOfClass(UITextField.classForCoder()) {
            return;
        }
        var window = UIApplication.sharedApplication().keyWindow;
        if window == nil {
            return;
        }
        
        var responderFrame = window?.convertRect(firstResponder!.frame, fromView: firstResponder?.superview);
        
        var userInfo = notification.userInfo;
        var value: NSValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue;
        var keyboardRect = value.CGRectValue();
        var animationDurationValue: NSValue = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSValue;
        var animationDuration:NSTimeInterval = 0;
        animationDurationValue.getValue(&animationDuration);
        
        
        var width = window!.frame.width;
        var height = window!.frame.height;
        var x:CGFloat = 0;
        var y:CGFloat = 0;
        
        if UIDevice.systemVersionFloatValue() > 8.0 {
            x = (keyboardRect.x == 0) ?0:(keyboardRect.x - responderFrame!.x - responderFrame!.height);
            y = (keyboardRect.y == 0) ?0:(keyboardRect.y - responderFrame!.y - responderFrame!.height);
            x = x > 0 ?0:x;
            y = y > 0 ?0:y;
        }else {
            var orientation = UIApplication.sharedApplication().statusBarOrientation;
            if orientation == UIInterfaceOrientation.PortraitUpsideDown {
                x = 0;
                y = responderFrame!.y - keyboardRect.height;
            }else if orientation == UIInterfaceOrientation.LandscapeLeft {
                x = keyboardRect.width - responderFrame!.x;
                y = 0;
            }else if orientation == UIInterfaceOrientation.LandscapeRight {
                x = responderFrame!.x - keyboardRect.width;
                y = 0;
            }else if orientation == UIInterfaceOrientation.Portrait {
                x = 0;
                y = keyboardRect.height - responderFrame!.y;
            }
        }
        
        var rect = CGRectMake(x, y, width, height);
        view.layoutIfNeeded();
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            window!.frame = rect;
        });
    }
    
    /**
    Reset the view controller's view
    
    :param: notification
    */
    func keyboardWillHide(notification:NSNotification) {
        var window = UIApplication.sharedApplication().keyWindow;
        if window == nil {
            return;
        }
        var userInfo = notification.userInfo!;
        var animationDurationValue:NSValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSValue;
        var animationDuration:NSTimeInterval = 0;
        animationDurationValue.getValue(&animationDuration);
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            window!.frame = CGRectMake(0, 0, window!.frame.width, window!.frame.height)
        });
    }
}

extension UIScrollView {
    public func bindKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil);
    }
    
    func keyboardWillShow(notification:NSNotification) {
        var firstResponder = self.findFirstResponderView();
        if firstResponder == nil {
            return;
        }
        if !firstResponder!.isKindOfClass(UITextField.classForCoder()) {
            return;
        }
        
        var respnderFrame = self.convertRect(firstResponder!.frame, fromView: firstResponder!.superview);
        self.scrollRectToVisible(respnderFrame, animated: true);
    }
}

extension UIColor {
    class func colorWithRGB(value:Int)->UIColor {
        var redValue = CGFloat(value & 0xFF0000 >> 16)/255.0;
        var greenValue = CGFloat(value & 0x00FF00 >> 8)/255.0;
        var blueValue = CGFloat(value & 0x0000FF)/255.0;
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1);
    }
}

extension UIView {
    /**
    Find the first responder sub view
    
    :returns: the first responder view.
    */
    public func findFirstResponderView()->UIView? {
        if self.isFirstResponder() {
            return self;
        }
        
        for subView in self.subviews {
            var view = subView.findFirstResponderView();
            if view != nil {
                return view;
            }
        }
        return nil;
    }
}

extension NSString {
    class public func isEmpty(string: NSString?)->Bool {
        if string == nil {
            return true;
        }
        
        if !string!.isKindOfClass(NSString.classForCoder()) {
            if string!.isKindOfClass(NSNull.classForCoder()) {
                return true;
            }else {
                return false;
            }
        }
        
        if string!.trim().length == 0 {
            return true;
        }
        return false;
    }
    
    public func trim()->NSString {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
    }
    
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let subStart = advance(self.startIndex, r.startIndex, self.endIndex)
            let subEnd = advance(subStart, r.endIndex - r.startIndex, self.endIndex)
            return self.substringWithRange(Range(start: subStart, end: subEnd))
        }
    }
    
    subscript (index: Int) -> Character {
        get {
            let subIndex = advance(self.startIndex, index, self.endIndex)
            return self[subIndex];
        }
    }
    
    func substring(from: Int) -> String {
        let end = count(self)
        return self[from..<end]
    }
    
    func substring(from: Int, length: Int) -> String {
        let end = from + length
        return self[from..<end]
    }
    
    func replace(index:Int, char:Character) ->String {
        var chars = Array(self);
        chars[index] = char;
        var modifiedStr = String();
        modifiedStr.extend(chars);
        return modifiedStr;
    }
}


extension Array {
    func containsObject(comparator:(T)->Bool)->Bool {
        for element in self {
            if comparator(element){
                return true
            }
        }
        return false;
    }
}
