//
//  DrawCashDetailViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class DrawCashDetailViewController: BaseTableViewController {
    @IBOutlet weak var bankCardLabel: UILabel!
    @IBOutlet weak var drawCashCount: UILabel!
    @IBOutlet weak var drawCashTime: UILabel!
    var acount: String?
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    //MARK: --DATA
    func initData() {
        let model: DrawCashModel  = DrawCashModel()
        model.uid = CurrentUserHelper.shared.userInfo.uid
        model.account = acount
        model.num = 1
        model.size = 1
        AppAPIHelper.userAPI().drawCashDetail(model, complete: { [weak self](result) in
            if result  == nil{
                return
            }
            
            let resultModel = result as! DrawCashModel
            if resultModel.withdraw_record?.count >= 0{
                let model =  resultModel.withdraw_record![0] as DrawCashRecordModel
                let bankNum = ((model.account)! as NSString).substringWithRange(NSRange.init(location: model.account!.length()-4, length: 4))
                let bankName = model.bank_name_
                
        
                self?.bankCardLabel.text =  "\(bankName)\(bankNum)）"
        
                self?.drawCashCount.text = "￥\(model.cash_)"
                
                self?.drawCashTime.text = model.request_time

            }
        }, error: errorBlockFunc())
    }
    //MARK: --UI
    func initUI() {
        navigationItem.backBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
    }

    @IBAction func finishBtnTapped(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
