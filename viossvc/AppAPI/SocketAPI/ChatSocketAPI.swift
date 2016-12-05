//
//  ChatSocketAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ChatSocketAPI:BaseSocketAPI, ChatAPI {

    func sendMsg(chatModel:ChatMsgModel,complete:CompleteBlock,error:ErrorBlock) {
        
        var dict = try? OEZJsonModelAdapter.jsonDictionaryFromModel(chatModel)
        dict?.removeValueForKey("isReading_");
        dict?.removeValueForKey("id_");
        let pack = SocketDataPacket(opcode: .ChatSendMessage, dict: dict as! [String:AnyObject])
        SocketRequestManage.shared.sendChatMsg(pack, complete: complete, error: error)
    }
    
    func offlineMsgList(uid:Int,complete:CompleteBlock,error:ErrorBlock) {
        let pack = SocketDataPacket(opcode: .ChatOfflineRequestMessage, dict: [SocketConst.Key.uid: uid])
        startModelsRequest(pack, listName: "msg_list_", modelClass: ChatMsgModel.classForCoder(), complete: complete, error: error)
    }
    
    func setReceiveMsgBlock(complete:CompleteBlock) {
        SocketRequestManage.shared.receiveChatMsgBlock = { (response) in
            let jsonResponse = response as! SocketJsonResponse
            let model:ChatMsgModel? = jsonResponse.responseJson()
            if  model != nil {
                complete(model)
            }
        }
    }
}
