//
//  DrawCashRecordViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class DrawCashRecordCell: OEZTableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func upCellData(data: AnyObject) {
        let model = data as! DrawCashRecordModel
        countLabel.text = "￥\(Double(model.cash)/100)"
        statusLabel.text = model.status == 0 ? "等待处理" : (model.status == 1 ? "提现成功" : "提现失败")
        statusLabel.textColor = model.status == 0 ? UIColor(RGBHex: 0xf7931e) : (model.status == 1 ? UIColor(RGBHex: 0x03a8ec)  : UIColor.blackColor() )
        let dateStr: NSString = model.request_time! as NSString
        let dateValue = dateStr.substringWithRange(NSRange.init(location: 5, length: 5))
        let timeVale = dateStr.substringWithRange(NSRange.init(location: 11, length: 8))
        dateLabel.text = dateValue
        timeLabel.text = timeVale
    }
}

class DrawCashRecordViewController: BasePageListTableViewController {
    var tableData: [[DrawCashRecordModel]] = []
    var model: DrawCashRecordModel?
    var detailController: DrawCashDetailViewController?
    
    override func didRequest(pageIndex: Int) {
        requestDrawCashData(pageIndex)
    }
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    //MARK: --DATA
    func requestDrawCashData(pageIndex: Int) {
        let model: DrawCashModel = DrawCashModel()
        model.uid = CurrentUserHelper.shared.userInfo.uid
//        model.account =  CurrentUserHelper.shared.userInfo.currentBankCardNumber
        model.size = 10
        model.num = pageIndex
        AppAPIHelper.userAPI().drawCashRecord(model, complete: {[weak self] (result) in
            
            if result == nil{
                self?.didRequestComplete(result)
                return
            }
            
            let resultModel: DrawCashModel = result as! DrawCashModel
            if self?.tableData.count == 0{
                self?.tableData = (self?.monthModel(resultModel.withdraw_record))!
            }else{
                self?.appendMonthModel(resultModel.withdraw_record, type: pageIndex)
            }
            self?.updateView()
        }, error: errorBlockFunc())
    }
    
    /**
     给所有数据按月分组
     
     - parameter models: 所有数据
     
     - returns: 分组后的数据
     */
    func monthModel(models: [DrawCashRecordModel]) -> [[DrawCashRecordModel]] {
        var totalModels: [[DrawCashRecordModel]] = []
        var monthModels: [DrawCashRecordModel] = []
        var month = 0
        for model in models {
            let date = NSDate.yt_convertDateStrToDate(model.request_time!, format: "yyyy-MM-dd HH-mm-ss")
            let requestMonth = date.yt_month()
            if requestMonth == month {
                monthModels.append(model)
            }else{
                month = requestMonth
                monthModels = []
                monthModels.append(model)
            }
        }
        if monthModels.count != 0 {
            totalModels.append(monthModels)
        }
        return totalModels
    }
    /**
     对下拉刷新和上拉加载的数据追加到原有分组数据中
     
     - parameter models:       新数据
     - parameter type:         1：下拉刷新，非1：上拉加载
     */
    func appendMonthModel(models: [DrawCashRecordModel],type: Int) {
        var monthModels: [DrawCashRecordModel] = []
        for model in models{
            let modelDate = NSDate.yt_convertDateStrToDate(model.request_time!, format: "yyyy-MM-dd HH-mm-ss")
            let modelLength = modelDate.timeIntervalSince1970
            let modelMonth = modelDate.yt_month()
            if type == 1{
                let firstModel = tableData.first?.first
                let firstMoth = NSDate.yt_convertDateStrToDate(firstModel!.request_time!, format: "yyyy-MM-dd HH-mm-ss").yt_month()
                let firstDateLength = NSDate.yt_convertDateStrToDate(firstModel!.request_time!, format: "yyyy-MM-dd HH-mm-ss").timeIntervalSince1970
                if modelLength > firstDateLength {
                    if firstMoth == modelMonth {
                        tableData[0].append(model)
                    }else{
                        monthModels = []
                        monthModels.append(model)
                        tableData.append(monthModels)
                    }
                }
            }else{
                let lastModel = tableData.last?.last
                let lastMoth = NSDate.yt_convertDateStrToDate(lastModel!.request_time!, format: "yyyy-MM-dd HH-mm-ss").yt_month()
                let lastDateLength = NSDate.yt_convertDateStrToDate(lastModel!.request_time!, format: "yyyy-MM-dd HH-mm-ss").timeIntervalSince1970
                if modelLength < lastDateLength {
                    if lastMoth == modelMonth {
                        tableData[tableData.count-1].append(model)
                    }else{
                        monthModels = []
                        monthModels.append(model)
                        tableData.append(monthModels)
                    }
                }
            }
            
        }
    }
    //MARK: --UI
    func initUI() {
        tableView.sectionHeaderHeight = 44
        tableView.rowHeight = 66
    }
    func updateView() {
        tableView.reloadData()
        endRefreshing()
        endLoadMore()
        setIsLoadData(true)
    }
    //MARK: --TableView's delegate and datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = tableData[section]
        return sectionData.count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstRowData: DrawCashRecordModel = tableData[section].first!
        let month = NSDate.yt_convertDateStrToDate(firstRowData.request_time!, format: "yyyy-MM-dd HH-mm-ss").yt_month()
        return "\(month)月"
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DrawCashRecordCell = tableView.dequeueReusableCellWithIdentifier(DrawCashRecordCell.className()) as! DrawCashRecordCell
        cell.upCellData(tableData[indexPath.section][indexPath.row])
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         detailController!.model = tableData[indexPath.section][indexPath.row]
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        detailController = segue.destinationViewController as? DrawCashDetailViewController
    }

}
