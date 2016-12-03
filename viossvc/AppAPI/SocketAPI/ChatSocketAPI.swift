//
//  ChatSocketAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ChatSocketAPI:BaseSocketAPI, ChatAPI {

    func sendMsg(chatModel:ChatModel,complete:CompleteBlock,error:ErrorBlock) {
        let pack = SocketDataPacket(opcode: .ChatSendMessage, model: chatModel)
        SocketRequestManage.shared.sendChatMsg(pack, complete: complete, error: error)
    }
    
    func offlineMsgList(uid:Int,complete:CompleteBlock,error:ErrorBlock) {
        let pack = SocketDataPacket(opcode: .ChatOfflineRequestMessage, dict: [SocketConst.Key.uid: uid])
        startModelsRequest(pack, listName: "msg_list_", modelClass: ChatModel.classForCoder(), complete: complete, error: error)
    }
    
    func setReceiveMsgBlock(complete:CompleteBlock) {
        SocketRequestManage.shared.receiveChatMsgBlock = { (response) in
            let jsonResponse = response as! SocketJsonResponse
            let model:ChatModel? = jsonResponse.responseJson()
            if  model != nil {
                complete(model)
            }
        }
    }
}
