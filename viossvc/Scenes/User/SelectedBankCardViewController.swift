//
//  SelectedBankCardViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class BankCardCell: OEZTableViewCell {
    @IBOutlet weak var bankCardNumLabel: UILabel!
    @IBOutlet weak var bankSelectBtn: UIButton!
}

class SelectedBankCardViewController: BaseListTableViewController{
    override func didRequest() {
        didRequestComplete(["","","","","","","","","",""]);
    }
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    //MARK: --DATA
    func initData() {
        
    }
    //MARK: --UI
    func initUI() {
        
    }

}
