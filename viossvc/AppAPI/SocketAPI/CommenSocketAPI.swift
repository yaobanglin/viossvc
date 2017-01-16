//
//  CommenSocketAPI.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class CommenSocketAPI: BaseSocketAPI,CommenAPI {
    func imageToken(complete: CompleteBlock, error: ErrorBlock) {
        startRequest(SocketDataPacket(opcode: .GetImageToken), complete: complete, error: error)
    }
    
    func heardBeat(uid: Int, complete: CompleteBlock, error: ErrorBlock) {
        startRequest(SocketDataPacket(opcode: .Heart,dict:[SocketConst.Key.uid: uid]), complete: complete, error: error)
    }
    
    func version(complete: CompleteBlock, error:ErrorBlock) {
        let packet = SocketDataPacket(opcode: .VersionInfo, dict: ["app_type_": 1])
        startRequest(packet, complete: complete, error: error)
    }
}
