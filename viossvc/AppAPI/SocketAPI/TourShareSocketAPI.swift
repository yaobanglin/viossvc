//
//  TourShareSocketAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class TourShareSocketAPI: BaseSocketAPI, TourShareAPI {
    
    func list(last_id: Int, count: Int,type:Int,complete: CompleteBlock, error: ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.last_id : last_id , SocketConst.Key.count : count, SocketConst.Key.page_type : type];
        let packet = SocketDataPacket(opcode: .TourShareList,dict: dict)
        startDataListRequest(packet,modelClass: TourShareModel.classForCoder(), complete: complete, error: error)
    }
    
    func detail(share_id: Int, complete: CompleteBlock, error: ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.share_id : share_id ];
        startModelRequest(SocketDataPacket(opcode: .TourShareDetail,dict: dict), modelClass: TourShareDetailModel.classForCoder(), complete: complete, error: error)
    }
    
    func type(complete:CompleteBlock,error:ErrorBlock) {
         startDataListRequest(SocketDataPacket(opcode: .TourShareType),modelClass: TourShareTypeModel.classForCoder(), complete: complete, error: error)
    }
}
