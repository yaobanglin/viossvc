//
//  SkillShareChatViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class SkillShareChatViewController: BasePageListTableViewController {
    
    var share_id:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad();
        MobClick.event(AppConst.Event.skillshare_comment)
    }

    override func didRequest(pageIndex: Int) {
        let last_id:Int = pageIndex == 1 ? 0 : (dataSource?.last as! SkillShareCommentModel).discuss_id
        AppAPIHelper.skillShareAPI().comment(share_id,last_id:last_id, count: AppConst.DefaultPageSize, complete: completeBlockFunc()
                , error:errorBlockFunc())
    }
    
    override func isCalculateCellHeight() -> Bool {
        return true
    }
    

}
