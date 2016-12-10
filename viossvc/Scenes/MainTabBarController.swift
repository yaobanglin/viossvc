//
//  MainTabBarViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad();
        //友盟的帐号统计
        MobClick.profileSignInWithPUID("\(CurrentUserHelper.shared.userInfo.uid)")
    }
    //友盟页面统计
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(MainTabBarController.className())
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(MainTabBarController.className())
    }
}
