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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didRequest(pageIndex: Int) {
    
        let last_id:Int = pageIndex == 1 ? 0 : (dataSource?.last as! OrderListModel).order_id
        currentPageIndex = pageIndex
        if currentPageIndex != 1 {
            
        }
        AppAPIHelper.orderAPI().list(last_id, count: 3, complete:  completeBlockFunc(), error: errorBlockFunc())
    }
    override func didRequest() {
        didRequest(1)
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

        performSegueWithIdentifier("orderToDetail", sender: indexPath)
  
        
    } else {
        let handleVC = HandleOrderViewController()
        handleVC.modalPresentationStyle = .Custom
        handleVC.delegate = self
        handleVC.setupDataWithModel(orderModel)
        presentViewController(handleVC, animated: true) {
            
        }
    }
    
    }

    func refreshList() {
        
        didRequest(currentPageIndex)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   
        
        if segue.destinationViewController is OrderDetailViewController {
        
            let indexPath = sender as! NSIndexPath
            
            let orderModel = dataSource![indexPath.row] as! OrderListModel
            
            let detailVC = segue.destinationViewController as! OrderDetailViewController
            detailVC.orderModel = orderModel
            
        }
    }
}


