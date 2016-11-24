//
//  BaseSocketAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/23.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class BaseSocketAPI: NSObject {
    
    func startRequest(packet: SocketDataPacket, complete: CompleteBlock, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet,complete: {  (response) in
            complete((response as? SocketJsonResponse)?.responseJsonObject())
            },error: error)
    }
    
    
    func startResultIntRequest(packet: SocketDataPacket, complete: CompleteBlock, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet,complete: {  (response) in
            complete((response as? SocketJsonResponse)?.responseResult())
            },error: error)
    }
    
    func startModelRequest(packet: SocketDataPacket, modelClass: AnyClass, complete: CompleteBlock?, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet, complete: {  (response) in
            complete?((response as? SocketJsonResponse)?.responseModel(modelClass))
            }, error: error)
    }
    
    
    func startModelsRequest(packet: SocketDataPacket, modelClass: AnyClass, complete: CompleteBlock?, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet, complete: {  (response) in
            complete?((response as? SocketJsonResponse)?.responseModels(modelClass))
            }, error: error)
    }
    
    
    func startModelsRequest(packet: SocketDataPacket, listName:String, modelClass: AnyClass, complete: CompleteBlock?, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet, complete: {  (response) in
            let dict:[String:AnyObject]? = ((response as? SocketJsonResponse)?.responseJsonObject()) as? [String:AnyObject]
            if dict != nil {
                 let array:[AnyObject]? = dict?[listName] as? [AnyObject]
                if array != nil  {
                    complete?(try! OEZJsonModelAdapter.modelsOfClass(modelClass, fromJSONArray: array))
                    return ;
                }
            }
            complete?([]);
            }, error: error)
    }

}
