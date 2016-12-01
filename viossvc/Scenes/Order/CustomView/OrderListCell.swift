//
// Created by yaowang on 2016/11/1.
// Copyright (c) 2016 ywwlcom.yundian. All rights reserved.
//

import UIKit

class OrderListCell : OEZTableViewCell {
    
    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
 
    let statusDict:Dictionary<OrderStatus, String> = [.WaittingAccept: "等待接受",//等待服务者接受
                                                              .Reject: "已拒绝",//服务者拒绝
                                                              .Accept: "已接受",//服务者接受
                                                         .WaittingPay: "等待支付",//等待消费者支付
                                                                .Paid: "支付完成",//已经支付
                                                              .Cancel: "已取消",//取消
                                                             .OnGoing: "进行中",//订单进行中
                                                           .Completed: "已完成",//服务者确定完成
                                                       .InvoiceMaking: "已完成",
                                                        .InvoiceMaked: "已完成"]
    
    let statusColor:Dictionary<OrderStatus, UIColor> = [.WaittingAccept: UIColor.init(red: 245/255.0, green: 164/255.0, blue: 49/255.0, alpha: 1),
                                                        .Reject: UIColor.redColor(),
                                                        
                                                        .Accept: UIColor.init(red: 245/255.0, green: 164/255.0, blue: 49/255.0, alpha: 1),
                                                        
                                                        .WaittingPay: UIColor.init(red: 245/255.0, green: 164/255.0, blue: 49/255.0, alpha: 1),
                                                        
                                                        .Paid: UIColor.greenColor(),
                                                        
                                                        .Cancel: UIColor.grayColor(),
                                                        
                                                        .OnGoing:  UIColor.init(red: 245/255.0, green: 164/255.0, blue: 49/255.0, alpha: 1),//订单进行中
        
                                                        .Completed:  UIColor.init(red: 245/255.0, green: 164/255.0, blue: 49/255.0, alpha: 1),
                                                        
                                                        .InvoiceMaking: UIColor.init(red: 245/255.0, green: 164/255.0, blue: 49/255.0, alpha: 1),
                                                        
                                                        .InvoiceMaked: UIColor.greenColor()]
    private var dateFormatter:NSDateFormatter = {
      
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter
        
    }()
    
    
    
    
    @IBAction func didSelectAction(sender: AnyObject) {
        
        didSelectRowAction(AppConst.Action.HandleOrder.rawValue, data: nil)
        
    }

    override func update(data: AnyObject!) {
        let orderListModel = data as! OrderListModel
        if orderListModel.from_url!.hasPrefix("http"){
            headPicImageView.kf_setImageWithURL(NSURL(string: orderListModel.from_url!), placeholderImage: UIImage(named: ""), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        
        nicknameLabel.text = orderListModel.from_name
        serviceLabel.text = orderListModel.service_name
        
        moneyLabel.text = "\(Float(orderListModel.order_price))元"
        statusLabel.text = statusDict[OrderStatus(rawValue: (orderListModel.order_status))!]
        statusLabel.textColor = statusColor[OrderStatus(rawValue: (orderListModel.order_status))!]
        timeLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(orderListModel.start_time)))
//            + "-" + dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(orderListModel.end_time)))

    }
}
