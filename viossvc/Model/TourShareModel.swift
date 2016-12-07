//
//  TourShareModel.swift
//  viossvc
//
//  Created by yaowang on 2016/11/23.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class TourShareModel: BaseModel {
    var share_id:Int = 0	//商务分享id
    var share_type:String!	//分享类别
    var share_theme:String!	//分享的title,eg."楼中楼"
    var per_cash:String!	//人均消费 eg."500元/人"
    var addr_region:String!	 //分享内容所处地域 eg."杭州商业中心"
    var telephone:String!	//联系电话
    var brief_pic:String!	//列表页展示图片
}

class TourShareDetailModel : TourShareModel {
    var addr_detail:String!	//详细地址
    var summary:String!	//详细介绍
    var detail_pic:String!	//详情页展示图片
}

class TourShareTypeModel : BaseModel {
    var type_id:Int  = 0	//类型id
    var type_title:String!	//类型名eg.美食/住宿/景点
    var type_pic:String!	//icon url
}