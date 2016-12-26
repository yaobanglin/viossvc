//
//  OrderListViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation



class OrderListViewController: BasePageListTableViewController,OEZTableViewDelegate, OrderRefreshDelegate{
    
    var currentPageIndex = 1
    var detailModel:OrderDetailModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event(AppConst.Event.order_list)
    }
    
    override func didRequest(pageIndex: Int) {
        
        let last_id:Int = pageIndex == 1 ? 0 : (dataSource?.last as! OrderListModel).order_id
        AppAPIHelper.orderAPI().list(last_id, count: AppConst.DefaultPageSize, complete:  completeBlockFunc(), error: errorBlockFunc())
    }

    override func didRequestComplete(data: AnyObject?) {
        let array = data as? Array<OrderListModel>
        
        if data != nil && array?.count > 0 {
            dataSource = data as? Array<AnyObject>
        }
        super.didRequestComplete(data)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didAction action: Int, data: AnyObject!) {
        
        let orderModel = dataSource![indexPath.row] as! OrderListModel
        /**
         *  如果订单已完成则跳转订单详情。反之弹出订单操作页
         */
        if orderModel.order_status > 6 {
            
            pushToDetailPage(indexPath)
            
        } else {
            let handleVC = HandleOrderViewController()
            handleVC.modalPresentationStyle = .Custom
            handleVC.delegate = self
            handleVC.setupDataWithModel(orderModel)
            handleVC.navigationVC = navigationController
            presentViewController(handleVC, animated: true) {
                
            }
        }
        
    }
    
    
    func refreshList() {
        
        beginRefreshing()
    }
    
    
    
    func pushToDetailPage(indexPath:NSIndexPath) {
        
        
        getOrderDetail(indexPath)
        
    }
    func getOrderDetail(indexPath:NSIndexPath) {
        let orderModel = dataSource![indexPath.row] as! OrderListModel
        unowned let weakSelf = self
        AppAPIHelper.orderAPI().getOrderDetail(orderModel.order_id, complete: { (response) in
            if response != nil{
                weakSelf.performSegueWithIdentifier("orderToDetail", sender: indexPath)
            }
            
            }, error: errorBlockFunc())
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.destinationViewController is OrderDetailViewController {
            
            let indexPath = sender as! NSIndexPath
            
            let orderModel = dataSource![indexPath.row] as! OrderListModel
            
            let detailVC = segue.destinationViewController as! OrderDetailViewController
            detailVC.orderModel = orderModel
            detailVC.detailModel = detailModel
            
        }
    }
}


