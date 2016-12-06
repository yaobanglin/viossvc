//
//  ChatManageHepler.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import XCGLogger


class ChatMsgHepler: NSObject {
    static let shared = ChatMsgHepler()
    var chatSessionHelper:ChatSessionHelper?
    override init() {
        super.init()
        AppAPIHelper.chatAPI().setReceiveMsgBlock { [weak self] (msg) in
            let chatModel = msg as? ChatMsgModel
            if chatModel != nil {
                self?.didChatMsg(chatModel!)
            }
        }
    }
    
    func sendMsg(toUid:Int,msg:String, type:Int = 0 ) {
        let chatModel = ChatMsgModel()
        chatModel.content = msg
        chatModel.msg_type = type
        chatModel.from_uid = CurrentUserHelper.shared.uid
        chatModel.to_uid = toUid
        chatModel.msg_time = Int(NSDate().timeIntervalSince1970)
        AppAPIHelper.chatAPI().sendMsg(chatModel, complete: { (obj) in
            
            }, error: { (error) in
            XCGLogger.debug("\(error)")
        })
        didChatMsg(chatModel)
    }
    
    func offlineMsgs() {
        AppAPIHelper.chatAPI().offlineMsgList(CurrentUserHelper.shared.uid, complete: { [weak self] (chatModels) in
                self?.didOfflineMsgsComplete(chatModels as? [ChatMsgModel])
            }, error: { (error) in
                XCGLogger.debug("\(error)")
        })
    }
    
    func didOfflineMsgsComplete(chatModels:[ChatMsgModel]!) {
        //!!!: 离线消息多时要优化
        for chatModel in chatModels {
            didChatMsg(chatModel)
        }
    }
    
    
    func findHistoryMsg(uid:Int,lastId:Int,pageSize:Int) -> [ChatMsgModel] {
        return ChatDataBaseHelper.ChatMsg.findHistoryMsg(uid, lastId: lastId, pageSize:pageSize)
    }
    

    func didChatMsg(chatMsgModel:ChatMsgModel)  {
        XCGLogger.debug("\(chatMsgModel)")
        ChatDataBaseHelper.ChatMsg.addModel(chatMsgModel)
        chatSessionHelper?.receiveMsg(chatMsgModel)
//        if chatMsgModel.from_uid != CurrentUserHelper.shared.uid {
//            sendMsg(chatMsgModel.from_uid, msg: chatMsgModel.content)
//        }
        
    }
}
