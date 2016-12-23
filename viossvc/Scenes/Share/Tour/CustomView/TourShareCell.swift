//
//  SkillShareCell.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit
import Kingfisher
class TourShareCell: OEZTableViewCell, OEZCalculateProtocol {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addrLabel: UILabel!
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return UIScreen.width() * 110.0 / 375.0  + 85.0;
    }

    @IBOutlet weak var didActionTel: UIButton!
    override func update(data: AnyObject!) {
        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
        let model = data as! TourShareModel
        titleLabel.text = model.share_theme
        addrLabel.text = model.addr_region
        typeLabel.text = model.share_type
        bannerImageView.kf_setImageWithURL(NSURL(string: model.brief_pic),placeholderImage:nil)
    }
    
    
    @IBAction func didActionTel(sender: AnyObject) {
        MobClick.event(AppConst.Event.share_phone)
        self.didSelectRowAction(AppConst.Action.CallPhone.rawValue, data: nil)
    }
}
