//
//  AddServerController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class AddServerController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var serviceNameText: UITextField!
    @IBOutlet weak var servicePriceText: UITextField!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeIconLabel: UILabel!
    enum PickType {
        case StartTime
        case EndTime
        case Type
    }
    var isTime: Bool = true
    var types = ["高端游", "商务游"]
    var pickType: PickType?
    var complete:CompleteBlock?
    var changeModel: UserServerModel?{
        didSet{
            if changeModel == nil {
                return
            }
            serviceNameText.text = changeModel?.service_name
            servicePriceText.text = "\(Double(changeModel!.service_price)/100)"
            startTimeLabel.text = timeStr((changeModel?.service_start)!)
            endTimeLabel.text = timeStr(changeModel!.service_end)
            typeLabel.text = changeModel!.change_type == 0 ? "高端游" : "商务游"
        }
    }
    
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK: --UI
    func initUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.userInteractionEnabled = true
        picker.showsSelectionIndicator = false
        
        for i in 100...102{
            let view = contentView.viewWithTag(i)
            view?.layer.cornerRadius = 4
            view?.layer.masksToBounds = true
        }
    }
    @IBAction func choseStarTime(sender: AnyObject) {
        pickType = .StartTime
        isTime = true
        showPickView()
    }
    @IBAction func choseEndTime(sender: AnyObject) {
        pickType = .EndTime
        isTime = true
        showPickView()
    }
    @IBAction func choseType(sender: AnyObject) {
        pickType = .Type
        isTime = false
        showPickView()
    }
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        hiddlePick()
        dismissController()
    }
    @IBAction func SureBtnTapped(sender: AnyObject) {
        if checkTextFieldEmpty([serviceNameText,servicePriceText]) {
            let model = UserServerModel()
            model.change_type = changeModel == nil ? 2 : 1
            model.service_name = serviceNameText.text
            model.service_price = Int(Double(servicePriceText.text!)! * 100)
            model.service_type = typeLabel.text == "高端游" ? 0 : 1
            model.service_start = time(startTimeLabel.text!)
            model.service_end = time(endTimeLabel.text!)
            if complete != nil {
                complete!(model) 
            }
            hiddlePick()
            dismissController()
        }
    }
    func time(timeStr: String) -> Int {
        let timeNSStr = timeStr as NSString
        let hourStr = timeNSStr.substringToIndex(2)
        let minuStr = timeNSStr.substringFromIndex(3)
        let minus = Int(hourStr)! * 60 + Int(minuStr)!
        return minus
    }
    func timeStr(minus: Int) -> String {
        let hour = minus / 60
        let leftMinus = minus % 60
        let hourStr = hour > 9 ? "\(hour)":"0\(hour)"
        let minusStr = leftMinus > 9 ? "\(minus)":"0\(leftMinus)"
        return "\(hourStr):\(minusStr)"
    }
    //MARK: --TextField
    func textFieldDidBeginEditing(textField: UITextField) {
        hiddlePick()
    }
    //MARK: --Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return isTime ?  2 : 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isTime ? (component == 0 ? 24 : 60) : types.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isTime == false {
            return types[row]
        }
        let title = row > 9 ? "\(row)" : "0\(row)"
        return  title
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickType == .Type {
            typeLabel.text  = types[row]
            return
        }
        var rowStr =  row > 9 ? "\(row)" : "0\(row)"
        if pickType == .StartTime {
            let hourStr = (self.startTimeLabel!.text! as NSString).substringToIndex(2)
            let minusStr = (self.startTimeLabel!.text! as NSString).substringFromIndex(3)
            startTimeLabel.text = component == 0 ? "\(rowStr):\(minusStr)" : "\(hourStr):\(rowStr)"
            return
        }
        if pickType == .EndTime {
            let hourStr = (self.endTimeLabel!.text! as NSString).substringToIndex(2)
            let minusStr = (self.endTimeLabel!.text! as NSString).substringFromIndex(3)
            if row == 0 && component == 0{
                rowStr = "24"
            }
            endTimeLabel.text = component == 0 ? "\(rowStr):\(minusStr)" : "\(hourStr):\(rowStr)"
            return
        }
        
    }
    func showPickView() {
        view.endEditing(true)
        timeIconLabel.hidden = pickType == .Type
        pickerViewBottomConstraint.constant = 0
        picker?.reloadAllComponents()
    }
    func hiddlePick() {
        pickerViewBottomConstraint.constant = -225
    }
    
}
