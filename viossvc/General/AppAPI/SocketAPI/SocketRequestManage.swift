//
//  SocketPacketManage.swift
//  viossvc
//
//  Created by yaowang on 2016/11/22.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit
import XCGLogger

class SocketRequestManage: NSObject {
    static var errorDict:NSDictionary?;
    static let shared = SocketRequestManage();
    class func errorString(code:Int) ->String {
        if errorDict == nil {
            if let bundlePath = NSBundle.mainBundle().pathForResource("errorcode", ofType: "plist") {
                errorDict = NSDictionary(contentsOfFile: bundlePath)
            }
        }
        let key:String = String(format: "%d", code);
        if errorDict?.objectForKey(key) != nil {
            return errorDict!.objectForKey(key) as! String
        }
        return "Unknown";
    }
    var socketRequests = [UInt32: SocketRequest]()
    private var _reqeustId:UInt32 = 10000
    var reqeustId:UInt32 {
        get {
            objc_sync_enter(self)
            if _reqeustId > 2000000000 {
                _reqeustId = 10000
            }
            _reqeustId += 1
            objc_sync_exit(self)
            return _reqeustId;
        }
    }

    func notifyResponsePacket(packet: SocketDataPacket) {
        objc_sync_enter(self)
        let socketReqeust = socketRequests[packet.request_id]
        socketRequests.removeValueForKey(packet.request_id)
        objc_sync_exit(self)
        let response:SocketJsonResponse = SocketJsonResponse(packet:packet)
        if (packet.type == SocketConst.type.Error.rawValue) {
            let dict:NSDictionary? = response.responseJson()
            var errorCode: Int? = dict?["error_"] as? Int
            if errorCode == nil {
                errorCode = -1;
            }
            let errorStr:String = SocketRequestManage.errorString(errorCode!)
            let error = NSError(domain: AppConst.Text.ErrorDomain, code: errorCode!
                , userInfo: [NSLocalizedDescriptionKey:errorStr]);
            dispatch_main_async( {
                socketReqeust?.error?(error)
            })
            
        } else {
            
            dispatch_main_async( {
               socketReqeust?.complete?(response)
            })
            
        }
    }
    
    
    
    private func dispatch_main_async(block:dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), {
            block()
        })
    }
    
    func startJsonRequest(packet: SocketDataPacket, complete: CompleteBlock, error: ErrorBlock) {
        let socketReqeust = SocketRequest();
        socketReqeust.error = error;
        socketReqeust.complete = complete;
        packet.request_id = reqeustId;
        objc_sync_enter(self)
        socketRequests[packet.request_id] = socketReqeust;
        objc_sync_exit(self)
        APISocketHelper.shared.sendData(packet.serializableData()!);
    }

}
