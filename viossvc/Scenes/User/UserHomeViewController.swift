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
    
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
    //MARK: --DATA
    func initData() {
        checkAuthStatus()
        requestUserCash { [weak self](result) in
            let userCash =  result as! Int
            self?.userCashLabel.text = "\(Double(userCash)/100)元"
        }
        
    }
    //MARK: --UI
    func initUI() {
        if (CurrentUserHelper.shared.userInfo.head_url != nil){
            let headUrl = NSURL.init(string: CurrentUserHelper.shared.userInfo.head_url!)
            userHeaderImage.kf_setImageWithURL(headUrl, placeholderImage: UIImage.init(named: "head_boy"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        
        if CurrentUserHelper.shared.userInfo.nickname != nil {
            userNameLabel.text = CurrentUserHelper.shared.userInfo.nickname
        }
        
        if CurrentUserHelper.shared.userInfo.praise_lv > 0 {
            for i in 100...104 {
                if i <= 100 + CurrentUserHelper.shared.userInfo.praise_lv {
                    let starImage: UIImageView = tableView.viewWithTag(i) as! UIImageView
                    starImage.image = UIImage.init(named: "my_star_fill")
                }
            }
        }
    }


    
}
