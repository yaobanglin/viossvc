//
//  ChatSessionHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

protocol ChatSessionsProtocol {
    func updates()
}

protocol ChatSessionProtocol {
    
    func receiveMsg(chatMsgModel:ChatMsgModel)
    
    func sessionUid() ->Int
}


class ChatSessionHelper: NSObject {
    static let shared = ChatSessionHelper()
    var chatSessions:[ChatSessionModel] = []
    var chatSessionsDelegate:ChatSessionsProtocol?
    private var currentChatSessionDelegate:ChatSessionProtocol?
    
    func openChatSession(chatSessionDelegate:ChatSessionProtocol) {
        currentChatSessionDelegate = chatSessionDelegate
        let chatSession = findChatSession(currentChatSessionDelegate!.sessionUid())
        chatSession.noReading = 0
        chatSessionsDelegate?.updates()
    }
    
    func  closeChatSession()  {
        currentChatSessionDelegate = nil
    }
    
    func receiveMsg(chatMsgModel:ChatMsgModel)  {
        let chatSession = findChatSession(chatMsgModel.from_uid)
        if chatSession.lastChatMsg == nil
            || chatSession.lastChatMsg.msg_time < chatMsgModel.msg_time {
            chatSession.lastChatMsg = chatMsgModel
            chatSessions.sortInPlace({ (chatSession1, chatSession2) -> Bool in
                return chatSession1.lastChatMsg.msg_time > chatSession2.lastChatMsg.msg_time
            })
        }
        
        if chatMsgModel.to_uid == CurrentUserHelper.shared.uid {
            if currentChatSessionDelegate != nil && currentChatSessionDelegate?.sessionUid() == chatMsgModel.from_uid {
                currentChatSessionDelegate?.receiveMsg(chatMsgModel)
            }
            else {
                chatSession.noReading += 1
            }
        }
        chatSessionsDelegate?.updates()
    }
    
    func updateChatSession(uid:Int,userInfo:UserInfoModel!) {
        if userInfo != nil {
            let chatSession = findChatSession(uid)
            chatSession.title = userInfo.nickname
        }
        chatSessionsDelegate?.updates()
    }
    
    func findChatSession(uid:Int) ->ChatSessionModel {
        for  chatSession in chatSessions {
            if chatSession.id == uid {
                return chatSession
            }
        }
        let chatSession = ChatSessionModel()
        chatSession.id = uid
        AppAPIHelper.userAPI().getUserInfo(uid, complete: { [weak self](model) in
            self?.updateChatSession(uid, userInfo: model as? UserInfoModel)
            }, error: {(error) in})
        chatSessions.insert(chatSession, atIndex: 0)
        return chatSession
    }
}
