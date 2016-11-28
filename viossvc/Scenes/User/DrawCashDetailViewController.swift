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
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    //MARK: --DATA
    func initData() {
        AppAPIHelper.userAPI().drawCashDetail(0, complete: { (result) in
            
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
