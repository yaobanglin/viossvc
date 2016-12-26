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
        var urlString:String?
        if bannerSrcs![pageIndex] is String {
            urlString = bannerSrcs![pageIndex] as? String
        }
        else if bannerSrcs![pageIndex] is SkillBannerModel {
            urlString = (bannerSrcs![pageIndex] as! SkillBannerModel).banner_pic
        }
    
        if urlString != nil {
            cell?.contentImage.kf_setImageWithURL(NSURL(string:urlString!), placeholderImage: UIImage(named: "750·378_placeholder"))
        }
        return cell;
    }
    
    override func update(data: AnyObject!) {
        bannerSrcs = data != nil ? data as? Array<AnyObject> : []
        pageView.pageControl.hidden = bannerSrcs?.count < 2
        pageView.scrollView.scrollEnabled = bannerSrcs?.count > 1
        pageView.reloadData()
        
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
