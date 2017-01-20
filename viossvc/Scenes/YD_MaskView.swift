//
//  YD_MaskView.swift
//  TestAdress
//
//  Created by J-bb on 16/12/28.
//  Copyright © 2016年 J-bb. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TouchMaskViewDelegate:NSObjectProtocol {
    

  optional func touchMaskView()
}

class YD_MaskView:UIView {
    
    var margin:CGFloat = 20.0
    weak var delegate:TouchMaskViewDelegate?
    var infoImageView:UIImageView = {
        let imageView = UIImageView()
        
        
        return imageView
    }()
    var arrowImageView:UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, 30, 28))
        imageView.image = UIImage(named: "jiantou_mask")
        
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        addSubview(arrowImageView)
        addSubview(infoImageView)
        
    }
    
    func setMaskFrame(maskFrame:CGRect, isTop:Bool, infoImage:String?, infoLeft:Bool) {
        
        setupMaksLayer(maskFrame)
        setupArrowImageView(maskFrame, isTop: isTop)
        guard infoImage != nil else {return}
        setupInfoImage(maskFrame, isTop: isTop, infoImage: infoImage, infoLeft: infoLeft)
        
    }
    

    
    
    //设置箭头
    private func setupArrowImageView(maskFrame:CGRect, isTop:Bool) {
        
        let centerX = maskFrame.origin.x + (maskFrame.size.width / 2)
        
        if isTop {
            arrowImageView.center = CGPointMake(centerX, CGRectGetMaxY(maskFrame) + margin + arrowImageView.frame.size.width / 2)
        }
        else {
            arrowImageView.center = CGPointMake(centerX, CGRectGetMaxY(maskFrame) - margin - arrowImageView.frame.size.height - arrowImageView.frame.size.width / 2)

        }
    }
    
    //设置提示信息
    private func setupInfoImage(maskFrame:CGRect, isTop:Bool, infoImage:String?, infoLeft:Bool) {
        
        let image = UIImage(named: infoImage!)
        
        guard image != nil else {return}
        infoImageView.image = image
        let width = image!.size.width
        let height = image!.size.height
        
        if isTop {
            let topY = CGRectGetMaxY(arrowImageView.frame) + margin
            if infoLeft {
                infoImageView.frame = CGRectMake(CGRectGetMaxX(maskFrame) - width, topY, width,height)
            } else {
                infoImageView.frame = CGRectMake(maskFrame.origin.x, topY, width, height)
            }
        } else {
            let bottomY = arrowImageView.frame.origin.y - margin - height
            if infoLeft {
                infoImageView.frame = CGRectMake(CGRectGetMaxX(maskFrame) - width, bottomY, width,height)
            } else {
                infoImageView.frame = CGRectMake(maskFrame.origin.x, bottomY, width, height)
            }
        }
    }
    
    
    //设置需要不遮罩的区域
   private func setupMaksLayer(maskFrame:CGRect) {
        
        
        let basePath = UIBezierPath(rect: bounds)
        
        let littlePath = UIBezierPath(rect:maskFrame).bezierPathByReversingPath()
        
        basePath.appendPath(littlePath)
        let maskLayer = CAShapeLayer()
        maskLayer.path = basePath.CGPath
        
        layer.mask = maskLayer
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        guard delegate != nil else {return}
        if delegate!.respondsToSelector(#selector(delegate?.touchMaskView)) {
            delegate!.touchMaskView!()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")

    }
    
}

