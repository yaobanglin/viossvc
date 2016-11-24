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
    var pageSize = 10
    override func viewDidLoad() {
        super.viewDidLoad();
    }

    override func didRequest(pageIndex: Int) {
        let last_id:Int = pageIndex == 1 ? 0 : (dataSource?.last as! SkillShareCommentModel).discuss_id
        AppAPIHelper.skillShareAPI().comment(share_id,last_id:last_id, count: pageSize, complete: { [weak self] (model) in
            self?.didRequestComplete(model)
            }, error:errorBlockFunc())
    }

}
