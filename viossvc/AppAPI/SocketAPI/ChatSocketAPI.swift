//
//  ChatSocketAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import XCGLogger
class ChatSocketAPI:BaseSocketAPI, ChatAPI {

    func sendMsg(chatModel:ChatMsgModel,complete:CompleteBlock,error:ErrorBlock) {
         XCGLogger.debug("\(chatModel)")
        var dict = try? OEZJsonModelAdapter.jsonDictionaryFromModel(chatModel)
        dict?.removeValueForKey("status_");
        dict?.removeValueForKey("id_");
        //对要发送的聊天信息进行编码
//        let utf8str = dict?["content_"]!.dataUsingEncoding(NSUTF8StringEncoding)
//        let content_base64 = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
//        dict?["content_"] = content_base64
        let pack = SocketDataPacket(opcode: .ChatSendMessage, dict: dict as! [String:AnyObject],type:.Chat)
        SocketRequestManage.shared.sendChatMsg(pack, complete: complete, error: error)
    }
    
    func offlineMsgList(uid:Int,complete:CompleteBlock,error:ErrorBlock) {
        let pack = SocketDataPacket(opcode: .ChatOfflineRequestMessage, dict: [SocketConst.Key.uid: uid],type:.Chat)
        startModelsRequest(pack, listName: "msg_list_", modelClass: ChatMsgModel.classForCoder(), complete: complete, error: error)
    }
    
    func setReceiveMsgBlock(complete:CompleteBlock) {
        SocketRequestManage.shared.receiveChatMsgBlock = { (response) in
            let jsonResponse = response as! SocketJsonResponse
            let model = jsonResponse.responseModel(ChatMsgModel.classForCoder()) as? ChatMsgModel
            if  model != nil {
                //解码
//                model?.content = try! self.decodeBase64Str(model!.content)
                complete(model)
            }
        }
    }
    
    func decodeBase64Str(base64Str:String) throws -> String{
        //解码
        let data = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions(rawValue: 0))
        let base64Decoded = String(data: data!, encoding: NSUTF8StringEncoding)
        return base64Decoded!
    }

}
