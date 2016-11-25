//
//  UIViewController+Extension.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation
import XCGLogger
import SVProgressHUD

extension UIViewController {
    
    static func storyboardViewController<T:UIViewController>(storyboard:UIStoryboard) ->T {
        return storyboard.instantiateViewControllerWithIdentifier(T.className()) as! T;
    }
    
    func storyboardViewController<T:UIViewController>() ->T {
        return storyboard!.instantiateViewControllerWithIdentifier(T.className()) as! T;
    }
    
    
    func errorBlockFunc()->ErrorBlock {
        return { [weak self] (error) in
            XCGLogger.error("\(error) \(self)");
            self?.showErrorWithStatus(error.localizedDescription)
            self?.endRefreshing()
            self?.errorLoadMore()
        }
    }
   
    func showErrorWithStatus(status: String!) {
        SVProgressHUD.showErrorWithStatus(status)
    }
    
    func showWithStatus(status: String!) {
        SVProgressHUD.showWithStatus(status)
    }

}