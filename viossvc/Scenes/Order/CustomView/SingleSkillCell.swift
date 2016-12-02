//
//  SingleSkillCell.swift
//  HappyTravel
//
//  Created by J-bb on 16/11/5.
//  Copyright © 2016年 J-bb. All rights reserved.
//

import UIKit

class SingleSkillCell: UICollectionViewCell {
    
    private lazy var deleteButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("-", forState: .Normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor =  UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1).CGColor
        button.setTitleColor( UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1), forState: .Normal)
        return button
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.whiteColor()
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .Center
        label.layer.borderColor = UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1).CGColor
        label.layer.borderWidth = 1.0
        label.textColor = UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    
   override  init(frame: CGRect) {
        super.init(frame: frame)
    contentView.backgroundColor = UIColor.whiteColor()
    contentView.addSubview(titleLabel)
    contentView.addSubview(deleteButton)
    
    titleLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
    }

    
    
    func setupTitle(text:String, labelWidth:CGFloat,showDeleteButton:Bool) {
        
        if showDeleteButton == true {
            
            deleteButton.frame = CGRectMake(frame.size.width - 10, -5, 20, 20)
            contentView.bringSubviewToFront(deleteButton)
            
            deleteButton.hidden = false
        } else {
            deleteButton.hidden = true
        }
        titleLabel.frame = CGRectMake(0, 0, labelWidth, frame.size.height)
        titleLabel.text = text
    }
    


    /**
     设置圆角、边框颜色、字体颜色、deleteButton隐藏
     
     - parameter textColor:
     - parameter borderColor:
     - parameter cornerRadius:
     - parameter isDelete:
     */
    private func  setUpWith(textColor:UIColor, borderColor:CGColor, cornerRadius:CGFloat, isDelete:Bool) {
        titleLabel.textColor = textColor
        titleLabel.layer.borderColor = borderColor
        titleLabel.layer.cornerRadius = cornerRadius

        deleteButton.hidden = !isDelete
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if CGRectContainsPoint(deleteButton.frame, point) {
            
            return self
        }
        return super.hitTest(point, withEvent: event)
    }
    
    

}
