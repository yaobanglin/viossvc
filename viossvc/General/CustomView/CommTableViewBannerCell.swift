//
//  SkillShareBannerCell.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class CommTableViewBannerCell: OEZTableViewPageCell {
    let cellIdentifier = "BannerImageCell";
    var bannerSrcs:[AnyObject]? = [];
    override func awakeFromNib() {
        super.awakeFromNib();
        pageView.registerNib(UINib(nibName: "PageViewImageCell",bundle: nil), forCellReuseIdentifier: cellIdentifier);
//        pageView.pageControl.currentPageIndicatorTintColor = AppConst.Color.CR;
        pageView.pageControl.pageIndicatorTintColor = AppConst.Color.C4;
    }
    override func numberPageCountPageView(pageView: OEZPageView!) -> Int {
        return bannerSrcs != nil ? bannerSrcs!.count : 0 ;
    }
    
    
   override func pageView(pageView: OEZPageView!, cellForPageAtIndex pageIndex: Int) -> OEZPageViewCell! {
    let cell:OEZPageViewImageCell? = pageView.dequeueReusableCellWithIdentifier(cellIdentifier) as? OEZPageViewImageCell;
        cell?.contentImage.image = UIImage(named: "test3");
        return cell;
    }
    
    override func update(data: AnyObject!) {
        if data != nil {
            bannerSrcs = data as? Array<AnyObject>;
            pageView.reloadData();
        }
    }

    
    func contentOffset(contentOffset:CGPoint)  {
        let yOffset:CGFloat  = contentOffset.y ;
        if  yOffset <= 0.0 {
            var  rect:CGRect = frame;
            rect.origin.y = yOffset ;
            rect.size.height = fabs(yOffset) + CGRectGetHeight(frame);
            rect.size.width = (rect.size.height * CGRectGetWidth(frame) / CGRectGetHeight(frame));
            rect.origin.x = (CGRectGetWidth(frame) - rect.size.width)/2;
            pageView.frame = rect;
        }
    }


}
