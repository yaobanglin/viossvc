//
//  PhotoWallCell.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

class PhotoWallCell: OEZTableViewCell, OEZCalculateProtocol {
    
    @IBOutlet weak var rightPhoto: UIImageView!
    @IBOutlet weak var centerPhoto: UIImageView!
    @IBOutlet weak var leftPhoto: UIImageView!
    @IBOutlet weak var timeLine: UIImageView!
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return UIScreen.width() * 110.0 / 375.0  + 85.0;
    }
    
    override func update(data: AnyObject!) {
        timeLine.kf_setImageWithURL(NSURL(string: "http://www.ld12.com/upimg358/allimg/c150808/143Y5Q9254240-11513_lit.png"), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        
        leftPhoto.kf_setImageWithURL(NSURL(string: "http://www.ld12.com/upimg358/allimg/c150808/143Y5Q9254240-11513_lit.png"), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        
        centerPhoto.kf_setImageWithURL(NSURL(string: "http://www.ld12.com/upimg358/allimg/c150808/143Y5Q9254240-11513_lit.png"), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        
        rightPhoto.kf_setImageWithURL(NSURL(string: "http://www.ld12.com/upimg358/allimg/c150808/143Y5Q9254240-11513_lit.png"), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        
    }
    
}
