//
//  TourShareAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

protocol  TourShareAPI {
    func list(last_id:Int,count:Int,type:Int,complete:CompleteBlock,error:ErrorBlock)
    func type(complete:CompleteBlock,error:ErrorBlock)
    func detail(share_id:Int,complete:CompleteBlock,error:ErrorBlock)
}
