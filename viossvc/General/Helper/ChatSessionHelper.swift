//
//  ChatSessionHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

protocol ChatSessionsProtocol : NSObjectProtocol {
    func updateChatSessions(chatSession:[ChatSessionModel])
}

protocol ChatSessionProtocol : NSObjectProtocol {
    
    func receiveMsg(chatMsgModel:ChatMsgModel)
    
    func sessionUid() ->Int
}


class ChatSessionHelper: NSObject {
    private var chatSessions:[ChatSessionModel] = []
    weak var chatSessionsDelegate:ChatSessionsProtocol?
    weak private var currentChatSessionDelegate:ChatSessionProtocol?
    
    init(chatSessionsDelegate:ChatSessionsProtocol) {
        super.init()
        self.chatSessionsDelegate = chatSessionsDelegate
        self.chatSessionsDelegate?.updateChatSessions(chatSessions)
    }
    func openChatSession(chatSessionDelegate:ChatSessionProtocol) {
        currentChatSessionDelegate = chatSessionDelegate
        let chatSession = findChatSession(currentChatSessionDelegate!.sessionUid())
        chatSession.noReading = 0
        updateChatSession(chatSession)
    }
    
    func  closeChatSession()  {
        currentChatSessionDelegate = nil
    }
    
    func receiveMsg(chatMsgModel:ChatMsgModel)  {
        var chatSession = findChatSession(chatMsgModel.from_uid)
        if chatSession == nil {
            chatSession = createChatSession(chatMsgModel.from_uid)
            chatSession.lastChatMsg = chatMsgModel
        }
        else if chatSession.lastChatMsg == nil
            || chatSession.lastChatMsg.msg_time < chatMsgModel.msg_time {
            chatSession.lastChatMsg = chatMsgModel
            chatSessions.sortInPlace({ (chatSession1, chatSession2) -> Bool in
                return chatSession1.lastChatMsg.msg_time > chatSession2.lastChatMsg.msg_time
            })
        }
        
        if currentChatSessionDelegate != nil && currentChatSessionDelegate?.sessionUid() == chatMsgModel.from_uid {
            currentChatSessionDelegate?.receiveMsg(chatMsgModel)
        }
        else if chatMsgModel.to_uid != CurrentUserHelper.shared.uid {
            chatSession.noReading += 1
        }
        
        updateChatSession(chatSession)
    }
    
    func updateUserInfo(uid:Int,userInfo:UserInfoModel!) {
        if userInfo != nil {
            let chatSession = findChatSession(uid)
            chatSession.title = userInfo.nickname
            chatSession.icon = userInfo.head_url
            updateChatSession(chatSession)
        }
        
    }
    
    func updateChatSession(chatSession:ChatSessionModel) {
        chatSessionsDelegate?.updateChatSessions(chatSessions)
    }
    
    
    func createChatSession(uid:Int) -> ChatSessionModel {
        let chatSession = ChatSessionModel()
        chatSession.sessionId = uid
        AppAPIHelper.userAPI().getUserInfo(uid, complete: { [weak self](model) in
            self?.updateUserInfo(uid, userInfo: model as? UserInfoModel)
            }, error: {(error) in})
        chatSessions.insert(chatSession, atIndex: 0)
        return chatSession

    }
    
    func findChatSession(uid:Int) ->ChatSessionModel! {
        for  chatSession in chatSessions {
            if chatSession.sessionId == uid {
                return chatSession
            }
        }
        return nil
    }
}
