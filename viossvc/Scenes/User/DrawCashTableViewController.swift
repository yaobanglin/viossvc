//
//  DrawCashTableViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/26.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class DrawCashTableViewController: BaseTableViewController, UITextFieldDelegate {
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
        //contentView
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        //drawCashBtn
        drawCashBtn.layer.cornerRadius = 5
        drawCashBtn.layer.masksToBounds = true
        drawCashBtn.enabled = false
        //cashNum
        cashNumLabel.text = "\(Double(CurrentUserHelper.shared.userInfo.user_cash_) / 100)"
        //drawCashText
        drawCashText.becomeFirstResponder()
    }
    
    func updateView(drawCash: String) {
        drawCashBtn.enabled = drawCash.characters.count != 0
        drawCashBtn.backgroundColor = drawCashBtn.enabled ? UIColor(RGBHex: 0x141f33) : UIColor(RGBHex: 0xaaaaaa)
        
        drawCashLabel.text =  "\(drawCash)元"
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
        
        let controller: DrawCashDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("DrawCashDetailViewController") as! DrawCashDetailViewController
        navigationController?.pushViewController(controller, animated: true)
        return
            
        AppAPIHelper.userAPI().checkDrawCashPassword(0, password: password, complete: { [weak self](result) in
            let model = DrawCashModel()
            AppAPIHelper.userAPI().drawCash(model, complete: { (result) in
                let controller: DrawCashDetailViewController = self?.storyboard?.instantiateViewControllerWithIdentifier("DrawCashDetailViewController") as! DrawCashDetailViewController
                self?.navigationController?.pushViewController(controller, animated: true)
            }, error: (self?.errorBlockFunc())!)
        }, error: errorBlockFunc())
    }
    
    //textField's Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let resultText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if resultText == "0" {
            return false
        }
        
        let userCash = CurrentUserHelper.shared.userInfo.user_cash_ / 100
        if (resultText.characters.count != 0 && Int(resultText)! > userCash ){
            showErrorWithStatus("提现金额超限")
            return false
        }
        updateView(resultText)
        return true
    }
}
