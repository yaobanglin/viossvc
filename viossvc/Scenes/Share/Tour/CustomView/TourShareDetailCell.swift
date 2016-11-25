//
//  TourShareDetailCell.swift
//  viossvc
//
//  Created by yaowang on 2016/11/1.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class TourShareDetailCell1: OEZTableViewCell , OEZCalculateProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addr1Label: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var addr2Label: UILabel!
    
    override func update(data: AnyObject!) {
        let model = data as! TourShareDetailModel
        titleLabel.text = model.share_theme
        addr1Label.text = model.addr_region
        addr2Label.text = model.addr_detail
        numLabel.text = model.per_cash
    }
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return 70.0;
    }

}


class TourShareDetailCell2: OEZTableViewCell , OEZCalculateProtocol {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        let model = data as! TourShareDetailModel
        let rect = model.summary.boundingRectWithSize(CGSizeMake(UIScreen.width()-CGFloat(34), 0),font:AppConst.SystemFont.S3,lineSpacing:5)
        return rect.height + 38
    }
    
    
    override func update(data:AnyObject!) {
        let model = data as! TourShareDetailModel
        contentLabel.attributedText = model.summary.attributedString(AppConst.SystemFont.S3,lineSpacing:5)
        contentLabel.sizeToFit()
    }
    
    
}
