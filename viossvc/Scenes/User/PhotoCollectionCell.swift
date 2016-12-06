//
//  PhotoCollectionCell.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

enum PhotoCollectionCellType : Int {
    case Normal = 0
    case UnSelect = 1
    case Selected = 2
    case CanRemove = 3
}

protocol PhotoCollectionCellDelegate: NSObjectProtocol {
    
    func rightTopButtonAction(indexPath: NSIndexPath?)
    
}

class PhotoCollectionCell: UICollectionViewCell {
    
    weak var delegate:PhotoCollectionCellDelegate?
    
    var photo:UIImageView?
    
    var typeBtn:UIButton?
    
    var type:PhotoCollectionCellType = .Normal
    
    var indexPath:NSIndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        photo = contentView.viewWithTag(1001) as? UIImageView
        if photo == nil {
            photo = UIImageView()
            photo?.tag = 1001
            photo?.frame = bounds
            contentView.addSubview(photo!)
        }
        
        typeBtn = contentView.viewWithTag(1002) as? UIButton
        if typeBtn == nil {
            let width = contentView.bounds.width / 4.0
            typeBtn = UIButton()
            typeBtn?.tag = 1002
            typeBtn?.backgroundColor = UIColor.whiteColor()
            typeBtn?.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
            typeBtn?.layer.cornerRadius = width / 2.0
            typeBtn?.layer.masksToBounds = true
            typeBtn?.layer.borderWidth = 1
            typeBtn?.layer.borderColor = UIColor.whiteColor().CGColor
            typeBtn?.frame = CGRectMake(width * 3, 0, width, width)
            typeBtn?.addTarget(self, action: #selector(rtBtnAction(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(typeBtn!)
        }
        
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, withEvent: event)
        if view == nil {
            let tmpPoint = typeBtn?.convertPoint(point, toView: contentView)
            if CGRectContainsPoint(typeBtn!.bounds, tmpPoint!) {
                view = typeBtn!
            }
        }
        return view
    }
    
    func rtBtnAction(sender: UIButton) {
        delegate?.rightTopButtonAction(indexPath)
    }
    
    func updateWithURL(url: String, indexPath:NSIndexPath?) {
        self.indexPath = indexPath
        update()
        self.photo?.kf_setImageWithURL(NSURL(string: url), placeholderImage: UIImage.init(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func updateWithImage(photo: UIImage, indexPath: NSIndexPath?) {
        self.indexPath = indexPath
        update()
        self.photo?.image = photo
    }
    
    func update() {
        switch type {
        case .Normal:
            typeBtn?.hidden = true
        
        case .UnSelect:
            typeBtn?.hidden = false
            typeBtn?.layer.borderColor = UIColor.whiteColor().CGColor
            typeBtn?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            typeBtn?.setTitle("V", forState: .Normal)
            
        case .Selected:
            typeBtn?.hidden = false
            typeBtn?.layer.borderColor = UIColor.init(RGBHex: 0x17893d).CGColor
            typeBtn?.backgroundColor = UIColor.init(RGBHex: 0x17893d)
            typeBtn?.setTitle("V", forState: .Normal)
            
        case .CanRemove:
            typeBtn?.hidden = false
            typeBtn?.layer.borderColor = UIColor.init(RGBHex: 0xe90000).CGColor
            typeBtn?.backgroundColor = UIColor.init(RGBHex: 0xe90000)
            typeBtn?.setTitle("X", forState: .Normal)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
