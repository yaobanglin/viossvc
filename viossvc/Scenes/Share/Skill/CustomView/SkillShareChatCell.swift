//
//  SkillShareChatCellTableViewCell.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class SkillShareChatCell: OEZTableViewCell ,OEZCalculateProtocol {

    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return 65;
    }
}
