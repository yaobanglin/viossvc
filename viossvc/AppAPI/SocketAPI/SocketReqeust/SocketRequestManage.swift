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
    
    static let shared = SocketRequestManage();
    private var socketRequests = [UInt32: SocketRequest]()
    private var _timer: NSTimer?
    private var _lastHeardBeatTime:NSTimeInterval!
    private var _lastConnectedTime:NSTimeInterval!
    private var _reqeustId:UInt32 = 10000
    private var _socketHelper:APISocketHelper?
    private var _sessionId:UInt64 = 0
    var receiveChatMsgBlock:CompleteBlock?
    
    func start() {
        _lastHeardBeatTime = timeNow()
        _lastConnectedTime = timeNow()
        stop()
        _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(didActionTimer), userInfo: nil, repeats: true)
        _socketHelper = APISocketHelper()
        _socketHelper?.connect()
    }
    
    func stop() {
        _timer?.invalidate()
        _timer = nil
        objc_sync_enter(self)
        _socketHelper?.disconnect()
        _socketHelper = nil
        objc_sync_exit(self)
    }
    
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
        if packet.operate_code == SocketConst.OPCode.ChatReceiveMessage.rawValue {
            let response:SocketJsonResponse = SocketJsonResponse(packet:packet)
            dispatch_async(dispatch_get_main_queue(), {[weak self] in
                self?.receiveChatMsgBlock?(response)
            })
        }
        else {
            objc_sync_enter(self)
            _sessionId = packet.session_id
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
                socketReqeust?.onError(errorCode)
            } else {
                socketReqeust?.onComplete(response)
            }
        }
    }
    
    
    func checkReqeustTimeout() {
        objc_sync_enter(self)
        for (key,reqeust) in socketRequests {
            if reqeust.isReqeustTimeout() {
                socketRequests.removeValueForKey(key)
                reqeust.onError(-11011)
                break
            }
        }
        objc_sync_exit(self)
    }
    
    
    private func sendRequest(packet: SocketDataPacket) {
        let block:dispatch_block_t = {
            [weak self] in
            self?._socketHelper?.sendData(packet.serializableData()!)
        }
        objc_sync_enter(self)
        if _socketHelper == nil {
            SocketRequestManage.shared.start()
            let when = dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC))
            dispatch_after(when,dispatch_get_main_queue(),block)
        }
        else {
            block()
        }
        objc_sync_exit(self)
    }
    
    func startJsonRequest(packet: SocketDataPacket, complete: CompleteBlock?, error: ErrorBlock?) {
        
        let socketReqeust = SocketRequest();
        socketReqeust.error = error;
        socketReqeust.complete = complete;
        packet.request_id = reqeustId;
        packet.session_id = _sessionId;
        objc_sync_enter(self)
        socketRequests[packet.request_id] = socketReqeust;
        objc_sync_exit(self)
        XCGLogger.debug("Request \(packet.operate_code) \(packet.request_id) \(packet.session_id)")
        sendRequest(packet)
    }
    
    func sendChatMsg(packet: SocketDataPacket,complete:CompleteBlock,error:ErrorBlock) {
        packet.request_id = reqeustId;
        packet.session_id = _sessionId;
        sendRequest(packet)
    }
    
    private func timeNow() ->NSTimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    private func lastTimeNow(last:NSTimeInterval) ->NSTimeInterval {
        return timeNow() - last
    }
    
    private func isDispatchInterval(inout lastTime:NSTimeInterval,interval:NSTimeInterval) ->Bool {
        if timeNow() - lastTime >= interval  {
            lastTime = timeNow()
            return true
        }
        return false
    }
    
    
    private func sendHeart() {
        let packet = SocketDataPacket(opcode: .Heart,dict:[SocketConst.Key.uid: CurrentUserHelper.shared.userInfo.uid])
        sendRequest(packet)
    }
    
    func didActionTimer() {
        if _socketHelper != nil && _socketHelper!.isConnected {
            if  CurrentUserHelper.shared.isLogin
                &&  isDispatchInterval(&_lastHeardBeatTime!,interval: 10) {
                sendHeart()
            }
            _lastConnectedTime = timeNow()
        }
        else if( isDispatchInterval(&_lastConnectedTime!,interval: 10) ) {
            _socketHelper?.connect()
        }
        checkReqeustTimeout()
    }

}
