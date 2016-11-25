//
//  SkillShareSocketAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/24.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class SkillShareSocketAPI: BaseSocketAPI,SkillShareAPI {
    func list(last_id:Int,count:Int,complete:CompleteBlock,error:ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.last_id : last_id , SocketConst.Key.count : count, SocketConst.Key.page_type : -1];
        startModelRequest(SocketDataPacket(opcode: .SkillShareList,dict: dict), modelClass: SkillShareListModel.classForCoder(), complete: complete, error: error)
    }
    
    func detail(share_id:Int,complete:CompleteBlock,error:ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.share_id : share_id ];
        startModelRequest(SocketDataPacket(opcode: .SkillShareDetail,dict: dict), modelClass: SkillShareDetailModel.classForCoder(), complete: complete, error: error)
        
    }
    
    func comment(share_id:Int,last_id:Int,count:Int,complete:CompleteBlock,error:ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.share_id:share_id,SocketConst.Key.last_id : last_id , SocketConst.Key.count : count];
        let packet = SocketDataPacket(opcode: .SkillShareComment,dict: dict)
        startDataListRequest(packet,modelClass: SkillShareCommentModel.classForCoder(), complete: complete, error: error)
    }
    
    func enroll(share_id:Int,uid:Int,complete:CompleteBlock,error:ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.share_id:share_id,SocketConst.Key.uid : uid]
        let packet = SocketDataPacket(opcode: .SkillShareEnroll,dict: dict)
        startResultIntRequest(packet, complete: complete, error: error)
        
    }
}

