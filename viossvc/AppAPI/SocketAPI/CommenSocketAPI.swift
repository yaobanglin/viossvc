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
    
    func heardBeat(complete: CompleteBlock, error: ErrorBlock) {
        startRequest(SocketDataPacket(opcode: .Heart), complete: complete, error: error)
    }
}
