//
//  OrderDetailViewController.swift
//  viossvc
//
//  Created by J-bb on 16/11/30.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController , LayoutStopDelegate{

    @IBOutlet weak var orderInfoView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var isOtherOrderView: UIView!
    
    @IBOutlet weak var isOtherOrderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var isOtherOrderInfoLabel: UILabel!
    @IBOutlet weak var tagsView: SkillLayoutView!
    @IBOutlet weak var tagsViewHeight: NSLayoutConstraint!

    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentMargin: NSLayoutConstraint!
    @IBOutlet weak var marginHeight: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var serviceCommentInfoLabel: UILabel!
    @IBOutlet weak var servantCommentInfoLabel: UILabel!
    @IBOutlet weak var commentRemarksTextView: UITextView!
    var skillDict:Dictionary<Int, SkillsModel> = [:]
    
    var orderModel:OrderListModel?
    var detailModel:OrderDetailModel?
    
    
    private var dateFormatter:NSDateFormatter = {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        return dateFormatter
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"

        tagsView.delegate = self
        
        getOrderDetail()
        
        /**
         *  如果订单是预约订单 加载技能标签信息
         */
        if orderModel?.order_type == 2 {
            getSkills()
        }
    }


    /**
     获取订单详情
     */
    func getOrderDetail() {
        
        unowned let weakSelf = self
        AppAPIHelper.orderAPI().getOrderDetail((orderModel?.order_id)!, complete: { (response) in
            if response != nil{
                let orderDetailModel = response as! OrderDetailModel
                weakSelf.detailModel = orderDetailModel
                weakSelf.setupDataWithModel(orderDetailModel)
            }
            
        }) { (error) in
        }
        
    }
    
    /**
     获取技能标签
     */
    func getSkills() {
        
        unowned let weakSelf = self
        AppAPIHelper.orderAPI().getSkills({ (response) in
            
            if response != nil {
                
                weakSelf.tagsView.hidden = false
                let array = response as? Array<SkillsModel>
                
                for skill in array! {
                    weakSelf.skillDict[skill.skill_id] = skill
                }
                /**
                 *  如果订单详情已经加载完成 获取预约订单所含技能标签信息
                 */
                if weakSelf.detailModel != nil {
                weakSelf.tagsView.dataSouce =  AppAPIHelper.orderAPI().getSKillsWithModel(weakSelf.detailModel!, dict:  weakSelf.skillDict)
                }
            }
            
            }) { (error) in
                
        }
        
    }
    /**
     技能标签高度回调
     
     - parameter height:
     */
    func layoutStopWithHeight(height: CGFloat) {
        tagsViewHeight.constant = height

    }
    
    
    /**
     
     填充数据
     - parameter detailModel:
     */
    func setupDataWithModel(detailModel:OrderDetailModel) {

        if detailModel.from_head != nil {

            headerImageView.kf_setImageWithURL(NSURL(string: detailModel.from_head!), placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            
        }
        nicknameLabel.text = detailModel.from_name
        serviceNameLabel.text = "【\(detailModel.service_name!)】"
        dateLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(detailModel.start))) + "-" + dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(detailModel.end)))

        cityLabel.text = detailModel.order_addr
        
        /**
         *  如果订单被评论过，显示评论信息，反之隐藏
         */
        if detailModel.has_evaluate == 0 {
            commentMargin.constant = 0
            commentView.hidden = true
            commentViewHeight.constant = 0
            
        } else {
            servantCommentInfoLabel.text = "服务者评价"
            serviceCommentInfoLabel.text = "\(detailModel.service_name!)"
            commentRemarksTextView.text = detailModel.evaluate__remarks
            
            for index in 1...detailModel.service_score {
                let button = commentView.viewWithTag(1000 + index) as? UIButton
               button?.selected = true
                
            }

            for index in 1...detailModel.user_score {
                let button = commentView.viewWithTag(2000 + index) as? UIButton
                button?.selected = true
            }
        }
        
        /**
         *  如果是订单是2 则为预约订单 展示相关信息 反之为邀约订单 隐藏相关
         */
        guard orderModel?.order_type == 2 else {
            isOtherOrderView.hidden = true
            commentMargin.constant = 0

            isOtherOrderViewHeight.constant = 0
            marginHeight.constant = 0
            tagsViewHeight.constant = 0
            tagsView.hidden = true
            return
        }
        
        /**
         *  如果技能信息已经加载完成（skillDict.count > 0），获取订单所含技能信息
         */
        if skillDict.count > 0 {
           tagsView.dataSouce = AppAPIHelper.orderAPI().getSKillsWithModel(detailModel, dict: skillDict)
            
        }
        /**
         *  如果是不是代订订单隐藏相关信息（detailModel.is_other == 0 ）
         */
        if detailModel.is_other == 0 {
            marginHeight.constant = 0
            isOtherOrderView.hidden = true
            isOtherOrderViewHeight.constant = 0
            
        } else {
            isOtherOrderInfoLabel.text = "代订: \(detailModel.other_name)  \(detailModel.other_phone)"
        }

        
    }
    
    
}
