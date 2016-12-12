//
//  ServerManagerViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD

class ServerManagerCell: OEZTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    var model:UserServerModel?
    
    override func update(data: AnyObject!) {
        let model = data as! UserServerModel
        self.model = model
        nameLabel.text = model.service_name
        priceLabel.text = "￥\(Double(model.service_price)/100)"
        timeLabel.text =  "\(time(model.service_start))--\(time(model.service_end))"
    }
    
    @IBAction func didDeleteBtnTapped(sender: UIButton) {
        didSelectRowAction(0, data: model)
    }
    
    func time(minus: Int) -> String {
        let hour = minus / 60
        let leftMinus = minus % 60
        let hourStr = hour > 9 ? "\(hour)" : "0\(hour)"
        let minusStr = leftMinus > 9 ? "\(minus)" : "0\(leftMinus)"
        return "\(hourStr):\(minusStr)"
    }
}


class ServerManagerViewController: BaseListTableViewController,OEZTableViewDelegate {
    var serverData: [UserServerModel]?
    var deleteData: [UserServerModel] = []
    var addData: [UserServerModel] = []
    var changeData: [UserServerModel] = []
    @IBOutlet weak var newServiceBtn: UIButton!
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        super.didRequestComplete(serverData)
        initUI()
    }
    //MARK: --UI
    func initUI() {
        newServiceBtn.layer.borderColor = UIColor.blackColor().CGColor
        newServiceBtn.layer.cornerRadius = 8
        newServiceBtn.layer.borderWidth = 0.5
        
        if serverData == nil || serverData?.count == 0 {
            //我的服务
            AppAPIHelper.userAPI().serviceList({ [weak self](result) in
                if result == nil {
                    return
                }
                self?.serverData = result as? [UserServerModel]
                self?.didRequestComplete(self?.serverData)
            }, error: errorBlockFunc())
        }
    }
    //删除服务
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didAction action: Int, data: AnyObject!) {
        MobClick.event(AppConst.Event.server_delete)
        let deleteModel = serverData![indexPath.row]
        for (index, model) in addData.enumerate() {
            if deleteModel == model {
                serverData!.removeAtIndex(indexPath.row)
                addData.removeAtIndex(index)
                super.didRequestComplete(serverData)
                return
            }
        }
        deleteData.append(deleteModel)
        serverData!.removeAtIndex(indexPath.row)
        super.didRequestComplete(serverData)
    }
    //更新服务
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller: AddServerController = storyboard?.instantiateViewControllerWithIdentifier(AddServerController.className()) as! AddServerController
        controller.modalPresentationStyle = .Custom
        presentViewController(controller, animated: true, completion: nil)
        let model = serverData![indexPath.row]
        controller.changeModel = model
        controller.complete = { [weak self] (result) in
            MobClick.event(AppConst.Event.server_update)
            let model: UserServerModel = result as! UserServerModel
            self?.changeData.append(model)
            self?.serverData?[indexPath.row] = model
            self?.didRequestComplete(self?.serverData)
        }
    }
    
    //新建服务
    @IBAction func newServiceBtnTapped(sender: UIButton) {
        MobClick.event(AppConst.Event.server_add)
        let controller: AddServerController = storyboard?.instantiateViewControllerWithIdentifier(AddServerController.className()) as! AddServerController
        controller.modalPresentationStyle = .Custom
        controller.complete = { [weak self] (result) in
            MobClick.event(AppConst.Event.server_add)
            let model: UserServerModel = result as! UserServerModel
            self?.addData.append(model)
            self?.serverData?.append(model)
            self?.didRequestComplete(self?.serverData)
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // next
    @IBAction func nextItemTapped(sender: AnyObject) {
        MobClick.event(AppConst.Event.server_sure)
        
        let model = UpdateServerModel()
        model.service_list = addData + changeData + deleteData
        if model.service_list.count == 0 {
            SVProgressHUD.showErrorMessage(ErrorMessage: "无任何修改", ForDuration: 1, completion: nil)
            return
        }
        model.uid = CurrentUserHelper.shared.userInfo.uid
        SVProgressHUD.showProgressMessage(ProgressMessage:"更新中...")
        AppAPIHelper.userAPI().updateServiceList(model, complete: {[weak self] (result) in
            SVProgressHUD.dismiss()
            self?.performSegueWithIdentifier(ServerSuccessController.className(), sender: nil)
        }, error: errorBlockFunc())
        
    }
    
}
