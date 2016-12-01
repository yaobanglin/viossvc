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
    

    override func update(data: AnyObject!) {
        let bankCardModel = data as! BankCardModel
        bankCardNumLabel.text = bankCardModel.bank_username_
        bankSelectBtn.selected = bankCardModel.is_default_ == 1 ? true : false

        
    }
}

class SelectedBankCardViewController: BaseListTableViewController{
    override func didRequest() {
        let model = BankCardModel()
        AppAPIHelper.userAPI().bankCards(model, complete: completeBlockFunc(), error: errorBlockFunc())
        
    }
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(BankCardCell.self)
        initUI()
    }
    override func didRequestComplete(data: AnyObject?) {
        
        dataSource = data as? Array<AnyObject>
        super.didRequestComplete(data)
    }
    //MARK: --DATA
    func initData() {
        let model = BankCardModel()
        unowned let weakSelf = self
        AppAPIHelper.userAPI().bankCards(model, complete: { (response) in
            guard response != nil else {return}
            let banksData = response as! NSArray
            weakSelf.dataSource = banksData as Array<AnyObject>
            weakSelf.tableView.reloadData()
        }) { (error) in
        }
    }
    

    //MARK: --UI
    func initUI() {
        
    }
    @IBAction func addNewBankCard() {
        performSegueWithIdentifier("bankCardToAddNew", sender: nil)

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
