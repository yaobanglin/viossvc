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
    /**
     获取订单详情
     
     - parameter orderid:  订单ID
     - parameter complete: 完成回调
     - parameter error:    错误回调
     */
    func getOrderDetail(orderid:Int,complete:CompleteBlock,error:ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.order_id : orderid]
        let packet = SocketDataPacket(opcode: .OrderDetail, dict: dict)
        startModelRequest(packet, modelClass: OrderDetailModel.classForCoder(), complete: complete, error: error)
        
    }
    
    /**
     获取全部技能标签
     */
    func getSkills(complete:CompleteBlock,error:ErrorBlock) {
       
        let packet = SocketDataPacket(opcode: .AllSkills)
    
        
        startModelsRequest(packet, listName: "skills_list_", modelClass: SkillsModel.classForCoder(), complete: complete, error: error)
        
        
    }
    
    /**
     *  获取预约订单对应的标签
     */
    func getSKillsWithModel(detailModel:OrderDetailModel, dict:[Int : SkillsModel]) -> Array<SkillsModel> {
        
        if detailModel.skills!.hasSuffix(",") {
            detailModel.skills?.removeAtIndex((detailModel.skills?.endIndex.predecessor())!)
        }
        let skillsIDArray:[String] = (detailModel.skills?.componentsSeparatedByString(","))!
        var array:[SkillsModel] = []
        
        for skillID in skillsIDArray {
            if skillID != "" {
                let Id = Int(skillID)
                
                array.append(dict[Id!]!)
            }
        }
        return array
    }
}
