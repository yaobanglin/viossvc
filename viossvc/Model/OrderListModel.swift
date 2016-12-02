//
//  OrderListModel.swift
//  viossvc
//
//  Created by J-bb on 16/11/30.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

/**
 订单状态
 
 - WaittingAccept: 等待接受
 - Reject:         已拒绝
 - Accept:         已接受（弃用）
 - WaittingPay:    等待支付
 - Paid:           已经支付
 - Cancel:         订单被取消
 - OnGoing:        订单进行中
 - Completed:      订单已完成
 - InvoiceMaking:  订单已申请开票
 - InvoiceMaked:   订单已开票
 */
enum OrderStatus : Int {
    case WaittingAccept = 0
    case Reject = 1
    case Accept = 2
    case WaittingPay = 3
    case Paid = 4
    case Cancel = 5
    case OnGoing = 6
    case Completed = 7
    case InvoiceMaking = 8
    case InvoiceMaked = 9
}
class OrderListModel: BaseModel {
    
    var order_id = 0
    var order_status = OrderStatus.WaittingAccept.rawValue
    var from_uid = -1
    var from_url:String?
    var from_name:String?
    var service_name:String?
    var order_price = 0
    var start_time = 0
    var end_time = 0
    var order_type = 0
    var is_other = 0
    var other_name:String?
    var other_phone:String?
    
    
}

class OrderDetailModel: BaseModel {
    var order_id = 0
    var order_status = OrderStatus.WaittingAccept.rawValue
    var order_price = 0
    var from_uid = -1
    var from_name:String?
    var from_head:String?
    var order_addr:String?
    var service_name:String?
    var start = 0
    var end = 0
    var is_other = 0
    var skills:String?
    var other_name:String?
    var other_gender = 0
    var other_phone:String?
    var has_evaluate = 0
    var service_score = 0
    var user_score = 0
    var evaluate__remarks:String?
}


class SkillsModel: BaseModel {
    
    var skill_id = 0
    var skill_name:String?
    var skill_type:String?
    
    
    
}







