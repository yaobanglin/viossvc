//
//  ChatManageHepler.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit


class ChatMsgHepler: NSObject {
    static let shared = ChatMsgHepler()
    var chatSessionHelper:ChatSessionHelper?
    override init() {
        super.init()
        AppAPIHelper.chatAPI().setReceiveMsgBlock { [weak self] (msg) in
            let chatModel = msg as? ChatMsgModel
            if chatModel != nil {
                self?.receiveMsg(chatModel!)
            }
        }
    }
    
    func sendMsg(toUid:Int,msg:String, type:Int = 0 ) {
        let chatModel = ChatMsgModel()
        chatModel.content = msg
        chatModel.type = type
        chatModel.from_uid = CurrentUserHelper.shared.uid
        chatModel.to_uid = toUid
        chatModel.msg_time = Int(NSDate().timeIntervalSince1970)
        AppAPIHelper.chatAPI().sendMsg(chatModel, complete: { (obj) in
            
            }, error: { (error) in
                
        })
        receiveMsg(chatModel)
    }
    
    func offlineMsgs() {
        AppAPIHelper.chatAPI().offlineMsgList(CurrentUserHelper.shared.uid, complete: { [weak self] (array) in
                self?.didOfflineMsgsComplete(array as? [ChatMsgModel])
            }, error: { (error) in
                
        })
    }
    
    func didOfflineMsgsComplete(array:[ChatMsgModel]!) {
        
    }
    
    

    func receiveMsg(chatMsgModel:ChatMsgModel)  {
        chatSessionHelper?.receiveMsg(chatMsgModel)
    }
}
