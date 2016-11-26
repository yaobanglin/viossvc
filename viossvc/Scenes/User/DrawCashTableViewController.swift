//
//  DrawCashTableViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/26.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class DrawCashTableViewController: BaseTableViewController {
    //MARK: 属性
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var cashNumLabel: UILabel!
    @IBOutlet weak var drawCashText: UITextField!
    @IBOutlet weak var drawCashLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var drawCashBtn: UIButton!
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    //MARK: --View
    func initView() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        drawCashBtn.layer.cornerRadius = 5
        drawCashBtn.layer.masksToBounds = true
    }
    //MARK: --DATA
    
    //MARK: --Function
    @IBAction func drawCashBtnTapped(sender: UIButton) {
        if checkTextFieldEmpty([drawCashText]) {
            view.endEditing(true)
            let passwordController: EnterPasswordViewController =  storyboard?.instantiateViewControllerWithIdentifier("EnterPasswordViewController") as! EnterPasswordViewController
            passwordController.modalPresentationStyle = .Custom
            passwordController.Password = { [weak self](password) in
                self?.drawCashRequest(password)
            }
            presentViewController(passwordController, animated: true, completion: { [weak self] in
                if let strongSelf = self{
                    passwordController.valueLabel.text = "￥\(strongSelf.drawCashText.text!)"
                }
            })
        }
    }
    
    func drawCashRequest(password: String) {
        
    }
}
