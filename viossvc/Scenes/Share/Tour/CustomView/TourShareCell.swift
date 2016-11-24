//
//  SkillShareCell.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

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
        
    }
}
