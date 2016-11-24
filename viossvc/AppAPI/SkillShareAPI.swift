//
//  SkillShareAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/24.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

protocol SkillShareAPI {
    func list(last_id:Int,count:Int,complete:CompleteBlock,error:ErrorBlock);
    func detail(share_id:Int,complete:CompleteBlock,error:ErrorBlock);
}
