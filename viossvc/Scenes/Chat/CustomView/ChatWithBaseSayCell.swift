//
//  CHatWithISayCell.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/2.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
class ChatWithBaseSayCell: OEZTableViewCell,OEZCalculateProtocol {
    @IBOutlet weak  var backImage : UIImageView!
    @IBOutlet weak  var detailLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.backgroundColor = UIColor.clearColor()
       
    }
    
    override func update(data: AnyObject!) {
 
     let   model = data as! ChatMsgModel
       
       detailLabel.attributedText = model.content.attributedString(AppConst.SystemFont.S14, lineSpacing: 3)
    }
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        let   model = data as! ChatMsgModel
        
        var  size = model.content.boundingRectWithSize(CGSizeMake(UIScreen.width() - 110,CGFloat.max), font: AppConst.SystemFont.S14, lineSpacing: 3).size
        let height = UIFont.HEIGHT(14)
        size.height = size.height < height ? height : size.height
        
        let labelheight = ceil(size.height)
        return labelheight + 19 * 2
        
    }

}
