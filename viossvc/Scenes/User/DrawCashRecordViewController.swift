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
    
    override func update(data: AnyObject!) {
        let model = data as! DrawCashRecordModel
        countLabel.text = "￥\(Double(model.cash_)/100)"
        statusLabel.text = model.status == 0 ? "等待处理" : (model.status == 1 ? "提现成功" : "提现失败")
        statusLabel.textColor = model.status == 0 ? UIColor(RGBHex: 0xf7931e) : (model.status == 1 ? UIColor(RGBHex: 0x03a8ec)  : UIColor.blackColor() )
        let dateStr: NSString = model.request_time! as NSString
        let dateValue = dateStr.substringWithRange(NSRange.init(location: 5, length: 5))
        let timeVale = dateStr.substringWithRange(NSRange.init(location: 11, length: 8))
        dateLabel.text = dateValue
        timeLabel.text = timeVale
    }
    
}

class DrawCashRecordViewController: BaseRefreshTableViewController {
    var tableData: [DrawCashRecordModel]?    
    override func didRequest(pageIndex: Int) {
        requestDrawCashData(pageIndex)
    }
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        didRequest(1)
    }
    //MARK: --DATA
    func requestDrawCashData(pageIndex: Int) {
        let model: DrawCashModel = DrawCashModel()
        model.uid = CurrentUserHelper.shared.userInfo.uid
        model.account =  CurrentUserHelper.shared.userInfo.currentBankCardNumber
        model.size = 1
        model.num = pageIndex
        AppAPIHelper.userAPI().drawCashRecord(model, complete: {[weak self] (result) in
            if result == nil{
                self?.didRequestComplete(self?.tableData);
                return
            }
            let resultModel: DrawCashModel = result as! DrawCashModel
            for model in resultModel.withdraw_record!{
                self?.tableData?.append(model)
            }
            self?.didRequestComplete(self?.tableData);
            
        }, error: errorBlockFunc())
    }

}
