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
        let dict:[String : AnyObject] = ["last_id_" : last_id , "count_" : count, "page_type_" : -1];
        startModelRequest(SocketDataPacket(opcode: .SkillShareList,dict: dict), modelClass: SkillShareListModel.classForCoder(), complete: complete, error: error)
    }
    
    func detail(share_id:Int,complete:CompleteBlock,error:ErrorBlock) {
        let dict:[String : AnyObject] = ["share_id_" : share_id ];
        startModelRequest(SocketDataPacket(opcode: .SkillShareDetail,dict: dict), modelClass: SkillShareDetailModel.classForCoder(), complete: complete, error: error)
        
    }
    
    func comment(share_id:Int,last_id:Int,count:Int,complete:CompleteBlock,error:ErrorBlock) {
        let dict:[String : AnyObject] = ["share_id_":share_id,"last_id_" : last_id , "count_" : count];
        startModelsRequest(SocketDataPacket(opcode: .SkillShareComment,dict: dict), listName:"data_list_", modelClass: SkillShareCommentModel.classForCoder(), complete: complete, error: error)
    }
}

