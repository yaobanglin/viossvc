//
//  CommenAPI.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

protocol CommenAPI {
    //获取上传图片token
    func imageToken(complete: CompleteBlock, error:ErrorBlock)
    //心跳包
    func heardBeat(uid: Int, complete: CompleteBlock, error: ErrorBlock)
}