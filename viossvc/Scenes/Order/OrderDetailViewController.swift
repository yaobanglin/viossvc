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

        setupData()
    }

    func setupData() {
        tagsView.delegate = self
        if detailModel != nil {
            setupDataWithModel(detailModel!)
        } else {
            getOrderDetail()
        }
        
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
            
            }, error: errorBlockFunc())
        
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
                    
                    let size = skill.skill_name!.boundingRectWithSize(CGSizeMake(0, 21), font: UIFont.systemFontOfSize(15), lineSpacing: 0)
                    skill.labelWidth = size.width + 30
                    weakSelf.skillDict[skill.skill_id] = skill
                    
                }
                /**
                 *  如果订单详情已经加载完成 获取预约订单所含技能标签信息
                 */
                if weakSelf.detailModel != nil {
                    weakSelf.tagsView.dataSouce =  AppAPIHelper.orderAPI().getSKillsWithModel(weakSelf.detailModel!.skills, dict:  weakSelf.skillDict)
                }
            }
        }, error: errorBlockFunc())
        
    }
    /**
     技能标签高度回调
     
     - parameter height:
     */

    func layoutStopWithHeight(layoutView:SkillLayoutView,height:CGFloat) {
         tagsViewHeight.constant = height
    }
    
    
    /**
     
     填充数据
     - parameter detailModel:
     */
    func setupDataWithModel(detailModel:OrderDetailModel) {


        setBaseInfo(detailModel)
        /**
         *  如果订单被评论过(detailModel.has_evaluate == 1)，显示评论信息，反之隐藏
         */
        if detailModel.has_evaluate == 0 {
            hideComment()
        } else {
            setDetailModelInfo(detailModel)
        }
        
        /**
         *  如果是订单是2 则为预约订单 展示相关信息 反之为邀约订单 隐藏相关
         */
        guard orderModel?.order_type == 2 else {
            hideYY_OrderInfo()
            return
        }
        
        /**
         *  如果技能信息已经加载完成（skillDict.count > 0），获取订单所含技能信息
         */
        if skillDict.count > 0 {
           tagsView.dataSouce = AppAPIHelper.orderAPI().getSKillsWithModel(detailModel.skills, dict: skillDict)
            
        }
        /**
         *  如果是不是代订订单隐藏相关信息（detailModel.is_other == 0 ）
         */
        if detailModel.is_other == 0 {
            hideOtherInfo()
        } else {
            isOtherOrderInfoLabel.text = "代订: \(detailModel.other_name!)  \(detailModel.other_phone!)"
        }

        
    }
    func setBaseInfo(detailModel:OrderDetailModel) {
        if detailModel.from_head != nil {
            headerImageView.kf_setImageWithURL(NSURL(string: detailModel.from_head!), placeholderImage: UIImage(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        nicknameLabel.text = detailModel.from_name
        serviceNameLabel.text = "【\(detailModel.service_name!)】"
        dateLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(detailModel.start))) + "-" + dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(detailModel.end)))
        
        cityLabel.text = detailModel.order_addr
    }
    
    func setDetailModelInfo(detailModel:OrderDetailModel) {
        servantCommentInfoLabel.text = "服务者评价"
        serviceCommentInfoLabel.text = "\(detailModel.service_name!)"
        commentRemarksTextView.text = detailModel.evaluate__remarks
        
        if detailModel.service_score != 0 {
            for index in 1...detailModel.service_score {
                let button = commentView.viewWithTag(1000 + index) as? UIButton
                button?.selected = true
                
            }
        }
        
        if detailModel.user_score != 0 {
            for index in 1...detailModel.user_score {
                let button = commentView.viewWithTag(2000 + index) as? UIButton
                button?.selected = true
            }
        }
    }
    
    func hideOtherInfo() {
        marginHeight.constant = 0
        isOtherOrderView.hidden = true
        isOtherOrderViewHeight.constant = 0

    }
    
    func hideYY_OrderInfo() {
        isOtherOrderView.hidden = true
        commentMargin.constant = 0
        
        isOtherOrderViewHeight.constant = 0
        marginHeight.constant = 0
        tagsViewHeight.constant = 0
        tagsView.hidden = true
    }
    
    func hideComment() {
        commentMargin.constant = 0
        commentView.hidden = true
        commentViewHeight.constant = 0

    }
}
