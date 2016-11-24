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
        
    }
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return 70.0;
    }

}


class TourShareDetailCell2: OEZTableViewCell , OEZCalculateProtocol {
    
    @IBOutlet weak var contentLabel: UILabel!
    override func update(data: AnyObject!) {
        
    }
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return 150.0
    }
    
}
