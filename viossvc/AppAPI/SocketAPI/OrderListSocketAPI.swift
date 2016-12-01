//
//  OrderListSocketAPI.swift
//  viossvc
//
//  Created by J-bb on 16/11/30.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class OrderListSocketAPI: BaseSocketAPI, OrderListAPI{
    
    /**
     请求订单列表
     - parameter last_id:  上一此请求id
     - parameter count:    每次请求数量
     - parameter complete: 请求完成回调
     - parameter error:    错误信息
     */
    func list(last_id:Int,count:Int,complete:CompleteBlock,error:ErrorBlock) {
        
        let dict:[String : AnyObject] = [SocketConst.Key.uid : CurrentUserHelper.shared.userInfo.uid, SocketConst.Key.last_id : last_id, SocketConst.Key.count : count]
        let packet = SocketDataPacket(opcode: .OrderList, dict: dict)
        startDataListRequest(packet, modelClass: OrderListModel.classForCoder(), complete: complete, error: error)
        
    }
    
    /**
     修改订单状态
     
     - parameter status:   修改后状态
     - parameter from_uid: 订单发起者 ID
     - parameter to_uid:   订单 to ID
     - parameter order_id: 订单ID
     */
    func modfyOrderStatus(status:Int, from_uid:Int,to_uid:Int, order_id:Int,complete:CompleteBlock,error:ErrorBlock) {
        
        let dict:[String : AnyObject] = [SocketConst.Key.order_id:order_id, SocketConst.Key.to_uid : to_uid, SocketConst.Key.from_uid: from_uid, SocketConst.Key.order_status : status]
        let packet = SocketDataPacket(opcode: .ModfyOrderStatus, dict: dict, type: SocketConst.type.Chat)
        startRequest(packet, complete: complete, error: error)
    }
}
