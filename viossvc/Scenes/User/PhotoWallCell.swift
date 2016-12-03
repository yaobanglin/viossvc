//
//  PhotoWallCell.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

class PhotoWallCell: OEZTableViewCell, OEZCalculateProtocol {
    
//    @IBOutlet weak var rightPhoto: UIImageView!
//    @IBOutlet weak var centerPhoto: UIImageView!
//    @IBOutlet weak var leftPhoto: UIImageView!
//    @IBOutlet weak var timeLine: UIImageView!
    
    var rightPhoto: UIImageView?
    var centerPhoto: UIImageView?
    var leftPhoto: UIImageView?
    var timeLine: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        
        if timeLine == nil {
            timeLine = UIImageView()
            timeLine?.image = UIImage.init(named: "head_giry")
            contentView.addSubview(timeLine!)
            timeLine?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(40)
                make.top.equalTo(contentView)
                make.bottom.equalTo(contentView)
                make.width.equalTo(20)
            })
        }
        
        var bgView = contentView.viewWithTag(1001)
        if bgView == nil {
            bgView = UIView()
            bgView?.tag = 1001
            bgView?.backgroundColor = UIColor.clearColor()
            contentView.addSubview(bgView!)
            bgView?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(timeLine!.snp_right).offset(14)
                make.right.equalTo(contentView).offset(-40)
                make.top.equalTo(contentView).offset(5)
                make.bottom.equalTo(contentView).offset(-5)
                make.height.equalTo(80)
            })
        }
        
        if leftPhoto == nil {
            leftPhoto = UIImageView()
            leftPhoto?.image = UIImage.init(named: "head_giry")
            contentView.addSubview(leftPhoto!)
            leftPhoto?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(bgView!)
                make.top.equalTo(bgView!)
                make.bottom.equalTo(bgView!)
                make.width.equalTo(80)
            })
        }
        
        if centerPhoto == nil {
            centerPhoto = UIImageView()
            centerPhoto?.image = UIImage.init(named: "head_giry")
            contentView.addSubview(centerPhoto!)
            centerPhoto?.snp_makeConstraints(closure: { (make) in
                make.center.equalTo(bgView!)
                make.top.equalTo(bgView!)
                make.bottom.equalTo(bgView!)
                make.width.equalTo(80)
            })
        }
        
        if rightPhoto == nil {
            rightPhoto = UIImageView()
            rightPhoto?.image = UIImage.init(named: "head_giry")
            contentView.addSubview(rightPhoto!)
            rightPhoto?.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(bgView!)
                make.top.equalTo(bgView!)
                make.bottom.equalTo(bgView!)
                make.width.equalTo(80)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return UIScreen.width() * 110.0 / 375.0  + 85.0;
    }
    
    override func update(data: AnyObject!) {
        if let photos = data as? [PhotoModel] {
            leftPhoto?.hidden = photos.count > 0 ? false : true
            centerPhoto?.hidden = photos.count > 1 ? false : true
            rightPhoto?.hidden = photos.count > 2 ? false : true
            
            for (index, photo) in photos.enumerate() {
                switch index {
                case 0:
                    leftPhoto?.kf_setImageWithURL(NSURL(string: photo.thumbnail_url!), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                    
                case 1:
                    centerPhoto?.kf_setImageWithURL(NSURL(string: photo.thumbnail_url!), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                case 2:
                    rightPhoto?.kf_setImageWithURL(NSURL(string: photo.thumbnail_url!), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                    
                default:
                    break
                }
            }
        }
        
    }
    
}
