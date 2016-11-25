//
//  SocketRequest.swift
//  viossvc
//
//  Created by yaowang on 2016/11/23.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit
import XCGLogger


class SocketRequest {
    
    static var errorDict:NSDictionary?;
    var error: ErrorBlock?
    var complete: CompleteBlock?
    var timestamp: NSTimeInterval = 0
    
    class func errorString(code:Int) ->String {
        if errorDict == nil {
            if let bundlePath = NSBundle.mainBundle().pathForResource("errorcode", ofType: "plist") {
                errorDict = NSDictionary(contentsOfFile: bundlePath)
            }
        }
        let key:String = String(format: "%d", code);
        if errorDict?.objectForKey(key) != nil {
            return errorDict!.objectForKey(key) as! String
        }
        return "Unknown";
    }

    
    deinit {
        
        XCGLogger.debug("deinit \(self)")
        
    }
    
    
    func isReqeustTimeout() -> Bool {
       return  timestamp + Double(AppConst.Network.TimeoutSec)  >= NSDate().timeIntervalSince1970
    }
    
    
    private func dispatch_main_async(block:dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), {
            block()
        })
    }
    
    
    func onComplete(obj:AnyObject!) {
        dispatch_main_async { 
            self.complete?(obj)
        }
    }
    
    
    func onError(errorCode:Int!) {
        let errorStr:String = SocketRequest.errorString(errorCode)
        let error = NSError(domain: AppConst.Text.ErrorDomain, code: errorCode
            , userInfo: [NSLocalizedDescriptionKey:errorStr]);
        onError(error)
    }
    
    func onError(error:NSError!) {
        dispatch_main_async {
            self.error?(error)
        }
    }
    
}
