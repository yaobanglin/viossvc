//
//  UserHomeViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class UserHomeViewController: BaseTableViewController {
    
    
    @IBOutlet weak var userCashLabel: UILabel!
    @IBOutlet weak var userHeaderImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bankCardNumLabel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心";
        
        requestUserCash()
        checkAuthStatus()
    }
    
    override func autoRefreshLoad() -> Bool {
        return false;
    }

    override func didRequest() {
        self.performSelector(#selector(endRefreshing), withObject: nil, afterDelay: 2);
    }

    func requestUserCash() {
        AppAPIHelper.userAPI().userCash(CurrentUserHelper.shared.userInfo.uid, complete: { [weak self](result) in
            if result == nil{
                return
            }
            let userCash: Int = result!["user_cash_"] == nil ? 0 : result!["user_cash_"] as! Int
            CurrentUserHelper.shared.userInfo.user_cash_ =  userCash
            self?.userCashLabel.text = "\(Double(userCash)/100)元"
        }, error: errorBlockFunc())
    }
}
