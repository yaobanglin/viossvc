//
//  HandleOrderViewController.swift
//  viossvc
//
//  Created by J-bb on 16/11/30.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
protocol OrderRefreshDelegate:NSObjectProtocol {
    
    func refreshList()
}

class HandleOrderViewController: UIViewController {
    @IBOutlet weak var appointOrOrderLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!

    @IBOutlet weak var headerImageVIew: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var remarksLabel: UILabel!
    
    @IBOutlet weak var otherOrderLabel: UILabel!
    
    @IBOutlet weak var sigleButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var appointmentView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    var orderModel:OrderListModel?
    
    var navigationVC:UINavigationController?
    
    weak var delegate:OrderRefreshDelegate?
    weak var listVC:OrderListViewController?
    private var dateFormatter:NSDateFormatter = {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerImageVIew.layer.cornerRadius = headerImageVIew.frame.size.width / 2
        headerImageVIew.layer.masksToBounds = true

    }

    
    func getOrderDetail() {
        
        unowned let weakSelf = self
        AppAPIHelper.orderAPI().getOrderDetail((orderModel?.order_id)!, complete: { (response) in
            
            if response != nil{
                let orderDetailModel = response as! OrderDetailModel
                if self.orderModel?.order_type != 0 {
                    weakSelf.remarksLabel.text = orderDetailModel.evaluate__remarks ?? "无"
                }
                weakSelf.locationLabel.text = orderDetailModel.order_addr
            }
            
        }, error: errorBlockFunc())
        
    }
    func setupDataWithModel(orderListModel:OrderListModel) {
        orderModel = orderListModel
        getOrderDetail()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        setData()
        setupActionButton()
    }
    
    func setData() {
        if orderModel?.from_url != nil{
            headerImageVIew.kf_setImageWithURL(NSURL(string: (orderModel?.from_url)!), placeholderImage: UIImage(named: "head_giry"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        startTimeLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(orderModel!.start_time)))
        endTimeLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(orderModel!.end_time)))
        nicknameLabel.text = orderModel!.from_name
        serviceNameLabel.text = orderModel!.service_name
        let isOrder = (orderModel!.order_type == 0)
        appointOrOrderLabel.text =  isOrder ? "邀约" : "预约"
        
        if isOrder {
            
            appointmentView.hidden = true
            bottomMargin.constant = 0
        } else {
            remark.text = "备注:"
            guard orderModel!.is_other != 0 else {
                bottomMargin.constant = 0

                return
            }
            otherOrderLabel.text = "代订:        \(orderModel!.other_name!) \(orderModel!.other_phone!)"
        }
        
    }
    
    func setupActionButton() {
        
        switch OrderStatus(rawValue: orderModel!.order_status)! {
      
        case .WaittingAccept:
            setUpActionViewWith(false, firstButtonTitle: "拒绝", secondButtonTitle: "接单", sigleButtonTitle: "", singleButtonEnabled: false)
            break
        case .Reject:
            setUpActionViewWith(true, firstButtonTitle: "", secondButtonTitle: "", sigleButtonTitle: "已拒绝", singleButtonEnabled: false)
            break
        case .Accept:
            setUpActionViewWith(true, firstButtonTitle: "", secondButtonTitle: "", sigleButtonTitle: "等待对方付款", singleButtonEnabled: false)
            break
        case .WaittingPay:
            setUpActionViewWith(true, firstButtonTitle: "", secondButtonTitle: "", sigleButtonTitle: "等待对方付款", singleButtonEnabled: false)
            break
        case .Paid:
            setUpActionViewWith(true, firstButtonTitle: "", secondButtonTitle: "", sigleButtonTitle: "开始服务", singleButtonEnabled: true)
            break
        case .OnGoing:
            setUpActionViewWith(true, firstButtonTitle: "", secondButtonTitle: "", sigleButtonTitle: "完成服务", singleButtonEnabled: true)
            break
        case .Cancel:
            setUpActionViewWith(true, firstButtonTitle: "", secondButtonTitle: "", sigleButtonTitle: "订单已取消", singleButtonEnabled: false)
            break
        case .Completed:
            
            break
        case .InvoiceMaking:
            
            break
        case .InvoiceMaked:
            
            break

        }

        
    }

    func setUpActionViewWith(actionViewHidden:Bool,firstButtonTitle:String, secondButtonTitle:String ,sigleButtonTitle:String, singleButtonEnabled:Bool) {
        
        actionView.hidden = actionViewHidden
        sigleButton.hidden = !actionViewHidden
        firstButton.setTitle(firstButtonTitle, forState: .Normal)
        secondButton.setTitle(secondButtonTitle, forState: .Normal)
        sigleButton.setTitle(sigleButtonTitle, forState: .Normal)
        sigleButton.enabled = singleButtonEnabled
    }
    

    @IBAction func sigleButtonAction(sender: AnyObject) {
        
        var status = 0
        switch OrderStatus(rawValue: orderModel!.order_status)! {
        case .Paid:
            status = 6
            break
        case .OnGoing:
            status = 7
            break
            
        default:
            break
        }
        
        modfyOrder(status)
    }
    
    @IBAction func acceptOrderAction(sender: AnyObject) {
        MobClick.event(AppConst.Event.order_accept)
        modfyOrder(OrderStatus.WaittingPay.rawValue)
    }

    @IBAction func rejectOrderAction(sender: AnyObject) {
        MobClick.event(AppConst.Event.order_refuse)
        modfyOrder(OrderStatus.Reject.rawValue)
    }
    
    /**
     根据status 修改订单
     回复状态（订单状态）1-拒绝 2-接收（已弃用接收邀请直接回复3）3-（同意邀请）等待支付
     6-服务进行中（开始服务）7-服务已完
     - parameter status:
     */
    func modfyOrder(status:Int) {
        
        unowned let weakSelf = self
        AppAPIHelper.orderAPI().modfyOrderStatus(status, from_uid: (orderModel?.from_uid)!, to_uid: CurrentUserHelper.shared.userInfo.uid, order_id: (orderModel?.order_id)!, complete: { (response) in
            if weakSelf.delegate != nil {
                weakSelf.delegate?.refreshList()
            }
            weakSelf.dismissViewControllerAnimated(true, completion: nil)
            
            }, error: errorBlockFunc())
    }
    
    @IBAction func chatAction(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController:ChatInteractionViewController = storyBoard.instantiateViewControllerWithIdentifier(ChatInteractionViewController.className()) as! ChatInteractionViewController
            viewController.chatUid = (orderModel?.from_uid)!
        viewController.chatName = (orderModel?.from_name)!
//        let navigationVC = UINavigationController(rootViewController: self)
        
        dismissViewControllerAnimated(true) { 
            
            self.navigationVC!.pushViewController(viewController, animated: true)
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}
