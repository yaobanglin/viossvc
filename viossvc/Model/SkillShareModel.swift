//
//  SkillShareModel.swift
//  viossvc
//
//  Created by yaowang on 2016/11/23.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class SkillBannerModel:BaseModel {
    var share_id:Int = 0
    var banner_pic:String!
}

class SkillShareListModel:BaseModel{
    var banner_list:[SkillBannerModel]!
    var data_list:[SkillShareModel]!
    
    class func banner_listModleClass() ->AnyClass {
        return SkillBannerModel.classForCoder()
    }
    
    class func data_listModleClass() ->AnyClass {
        return SkillShareModel.classForCoder()
    }
    
}

class SkillShareModel: BaseModel {
    var share_id:Int = 0	//技能分享id
    var share_theme:String!	//技能分享主题
    var share_user:String!	//主讲人
    var user_label:String!	//主讲人职称
    var share_start:Int = 0	//技能分享时间
    var share_status:Int = 0	//int	0-已结束 1-正在筹备 2-正在进行
    var brief_pic:String!	//列表页显示图片url
    var entry_num:Int = 0	//报名人数
}

class SkillShareDetailModel : SkillShareModel {
    var share_head:String!	//主讲人头像
    var share_end:Int = 0		//技能分享结束时间
    var detail_pic:String!	//详情页显示图片url
    var summary:String!	//详情
    var user_list:[UserModel]!//报名者列表
    class func user_listModleClass() ->AnyClass {
        return UserModel.classForCoder()
    }
}

class SkillShareCommentModel : UserModel {
    var discuss_id:Int = 0	//技能讨论id
    var content:String!	//讨论内容
    var discuss_time:Int = 0	//发言时间
}