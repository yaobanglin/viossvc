//
//  UserWalletViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class UserWalletViewController: BaseTableViewController {
    
    @IBOutlet weak var userCashLabel: UILabel!
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        userCashLabel.text = "\(Double(CurrentUserHelper.shared.userInfo.user_cash_)/100)元"
    }

    
}
