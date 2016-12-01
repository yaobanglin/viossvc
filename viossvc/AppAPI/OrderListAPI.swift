//
//  OrderListAPI.swift
//  viossvc
//
//  Created by J-bb on 16/11/30.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation
protocol OrderListAPI {
    func list(last_id:Int,count:Int,complete:CompleteBlock,error:ErrorBlock)
    
    func modfyOrderStatus(status:Int, from_uid:Int,to_uid:Int, order_id:Int,complete:CompleteBlock,error:ErrorBlock)
}