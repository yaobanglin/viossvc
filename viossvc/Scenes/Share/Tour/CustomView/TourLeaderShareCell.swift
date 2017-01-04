//
//  TourLeaderShareCell.swift
//  viossvc
//
//  Created by abx’s mac on 2016/11/30.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class TourLeaderShareCell: OEZTableViewHScrollCell,OEZCalculateProtocol {

    var shareModelArray : [TourShareTypeModel] = []
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        hScrollView.registerNib(UINib.init(nibName: "TourLeaderShareScrollView", bundle: nil), forCellReuseIdentifier: "TourLeaderShareScrollView")
    }
    
    override func update(data: AnyObject!) {
        shareModelArray = data as! [TourShareTypeModel]

        
        hScrollView.reloadData()
        
        
        
    }
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return 105
    }
    
    override func numberColumnCountHScrollView(hScrollView: OEZHScrollView!) -> Int {
        return  shareModelArray.count
    }
    
    override func hScrollView(hScrollView: OEZHScrollView!, widthForColumnAtIndex columnIndex: Int) -> CGFloat {
        return UIScreen.width() / 4.0
    }
    
    
    override func hScrollView(hScrollView: OEZHScrollView!, cellForColumnAtIndex columnIndex: Int) -> OEZHScrollViewCell! {
        
        let cell = hScrollView.dequeueReusableCellWithIdentifier("TourLeaderShareScrollView") as? TourLeaderShareScrollView
        
    
    
        cell?.update(shareModelArray[columnIndex])
        
        return cell
        
    }
    
    override func hScrollView(hScrollView: OEZHScrollView!, didSelectColumnAtIndex columnIndex: Int) {
         didSelectRowColumn(UInt(columnIndex))
        
    }
}

class TourLeaderShareScrollView : OEZHScrollViewCell {
    let imageView : UIImageView = UIImageView.init()
    let titleName : UILabel = UILabel.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let  edge : CGFloat = (UIScreen.width() / 4.0 - 55 ) / 2.0
                imageView.frame = CGRectMake(edge , 10, 55, 55)
                imageView.layer.cornerRadius = 55 / 2.0
                imageView.layer.masksToBounds = true
//                imageView.backgroundColor = UIColor.blueColor()
                titleName.frame = CGRectMake(0, 65,UIScreen.width() / 4.0, 105 - 65)
                titleName.font = UIFont.systemFontOfSize(13)
                titleName.textColor = UIColor(RGBHex: 0x131F32)
                titleName.textAlignment = NSTextAlignment.Center
                //
                        self.addSubview(imageView)
                        self.addSubview(titleName)
    }
    
    

    

    override func update(data: AnyObject!) {
        let model = data as! TourShareTypeModel
        
        imageView.kf_setImageWithURL(NSURL.init(string: model.type_pic), placeholderImage: UIImage(named: "square_placeholder"))
        titleName.text = model.type_title
    }
    
}


