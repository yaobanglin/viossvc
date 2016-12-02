//
//  SkillWidthLayout.swift
//  HappyTravel
//
//  Created by J-bb on 16/11/5.
//  Copyright © 2016年 J-bb. All rights reserved.
//

import UIKit
protocol SkillWidthLayoutDelegate : NSObjectProtocol {

    func autoLayout(layout:SkillWidthLayout, atIndexPath:NSIndexPath)->Float
}

class SkillWidthLayout: UICollectionViewFlowLayout {

    
    /**
     默认属性 可外部修改
     */

    var columnMargin:CGFloat = 0.0
    var rowMargin:CGFloat = 6.0
    var skillSectionInset = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)
    var itemHeight:CGFloat = 24.0
    var finalHeight:Float = 0.0
    /*
     需实现代理方法获取width 
     */
    weak var delegate:SkillWidthLayoutDelegate?

    var isLayouted = false
    
    
   private var currentX:Float = 0.0
   private var currentY:Float = 0.0
   private var currentMaxX:Float = 0.0
   private var attributedAry:Array<UICollectionViewLayoutAttributes>?
    
    

    override init() {
        super.init()
        
         columnMargin = 10.0
         rowMargin = 10.0
         skillSectionInset = UIEdgeInsetsMake(10.0, 16.0, 16.0, 16.0)
         itemHeight = 30.0
        attributedAry =  Array()
        
        
    }


    required init?(coder aDecoder: NSCoder) {
        columnMargin = 10.0
        rowMargin = 10.0
        skillSectionInset = UIEdgeInsetsMake(10.0, 16.0, 16.0, 16.0)
        itemHeight = 24.0
        attributedAry =  Array()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
        重写layout
     */
    
    
    override func prepareLayout() {
        currentX = Float(skillSectionInset.left)
        currentY = Float(skillSectionInset.top)
        currentMaxX = currentX
        attributedAry?.removeAll()
        if let count = collectionView?.numberOfItemsInSection(0) {
            for index in 0..<count {
                let atr = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
                
                attributedAry?.append(atr!)
                if index == count - 1 {
                    isLayouted = true
                    /**
                     在最后一个layout结束后 发送通知
                     
                     */
                    NSNotificationCenter.defaultCenter().postNotificationName("LayoutStop", object: nil, userInfo: nil)
                }
                
            }
        }

    }
    
    /**
     
     判断是否需要重新计算layout
     - parameter newBounds:
     
     - returns:
     */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {


        return !isLayouted
//        let oldBounds = collectionView?.bounds
//        if CGRectGetWidth(oldBounds!) != CGRectGetWidth(newBounds) {
//            
//            return true
//        } else {
//            return false
//        }
    }
    
    /**
     计算collectionView的Contensize
     
     - returns:
     */
    override func collectionViewContentSize() -> CGSize {
        
        if let atr = attributedAry?.last {
            
            let frame = atr.frame
            let height = CGRectGetMaxY(frame) + skillSectionInset.bottom
            return CGSizeMake(0, height)
        }
        return CGSizeMake(0, 0)
    }
    /**
     
    返回每个cell的layout
     - parameter indexPath:
     
     - returns:
     */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
       // storyBoard宽度 在layout的时候是在storyboard文件上的宽度，所以这里用屏幕宽度
//        let maxWidth = collectionView?.frame.size.width
        let maxWidth = UIScreen.mainScreen().bounds.width
        
        
        let itemW = delegate!.autoLayout(self, atIndexPath:indexPath)
        
        let atr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        atr.frame = CGRectMake(CGFloat(currentX), CGFloat(currentY), CGFloat(itemW), itemHeight)
        currentMaxX = currentX + itemW + Float(skillSectionInset.right)
        if currentMaxX - Float(maxWidth) > 0 {
            currentX = Float(skillSectionInset.left)
            currentY = currentY + Float(itemHeight) + Float(rowMargin)
            atr.frame = CGRectMake(CGFloat(currentX), CGFloat(currentY), CGFloat(itemW), itemHeight)
            currentX = currentX + itemW + Float(columnMargin)
        } else {
            currentX = currentX + itemW + Float(columnMargin)
        }
        finalHeight = currentY + Float(itemHeight) + Float(skillSectionInset.bottom)
        print(finalHeight)
        print(currentMaxX)
        return atr
    }
    
    /**
     
     layout数据源
     - parameter rect:
     
     - returns:
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributedAry
    }
    
}

