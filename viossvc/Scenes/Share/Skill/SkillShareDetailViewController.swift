//
//  SkillShareDetailViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class SkillShareDetailViewController: BaseCustomRefreshTableViewController,OEZTableViewDelegate {
    
    var share_id:Int = 0
    var detailModel:SkillShareDetailModel?
    @IBOutlet weak var bannerView: CommTableViewBannerCell!
    @IBOutlet weak var enrollButton: UIButton!
    @IBOutlet weak var enroolButtonHeightConstraint: NSLayoutConstraint!
    
    var chatView:UIView? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame:CGRect = bannerView.frame
        frame.size.height = UIScreen.width()*185.0/375.0
        bannerView.frame = frame
        tableView.tableHeaderView = bannerView
        enroolButtonHeightConstraint.constant = 0
    }
    override func refreshWhiteMode() -> Bool {
        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        navigationController?.navigationBar.subviews[0].alpha = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true);
        navigationController?.navigationBar.subviews[0].alpha = 1
    }
    //MARK:TableViewHelperProtocol
    override func isCalculateCellHeight() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        return detailModel
    }
    
    //MARK: -UITableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return detailModel != nil ? 4 : 0
    }
    

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 1 ? 10.0 : 0.0;
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didAction action: Int, data: AnyObject!) {
        if action == SkillShareDetailCell.selectTabAction {
            if let selectIndex:UInt? = data as? UInt {
                 self.didSelectTab(selectIndex!);
            }
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        bannerView.contentOffset(scrollView.contentOffset);
        if self.chatView?.hidden == false {
            updateChatViewFrame();
        }
        
    }
    
    
    func didSelectTab(selectIndex:UInt) {
        if chatView == nil {
            let chatViewController:SkillShareChatViewController = storyboardViewController()
            chatViewController.share_id = share_id
            addChildViewController(chatViewController)
            chatView = chatViewController.view
            view.addSubview(chatView!)
        }
        let isShowChatView:Bool = selectIndex == 1
        if isShowChatView {
            self.updateChatViewFrame()
        }
        self.chatView?.hidden = !isShowChatView
    }
    
    func updateChatViewFrame() {
        var rect:CGRect = tableView.rectForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0));
        rect = tableView.convertRect(rect, toView: tableView.superview)
        rect.origin.y += rect.height
        rect.size.height = CGRectGetHeight(view.frame) - rect.origin.y
        chatView?.frame = rect
    }
    
    override func didRequest() {
        AppAPIHelper.skillShareAPI().detail(share_id, complete: completeBlockFunc(), error: errorBlockFunc())
    }
    
    override func didRequestComplete(data: AnyObject?) {
        detailModel = data as? SkillShareDetailModel;
        if detailModel != nil && detailModel!.detail_pic != nil {
            bannerView.update([detailModel!.detail_pic]);
        }
        if detailModel?.share_status == 1 {
            bindUserEnroll();
        }
        
        super.didRequestComplete(data);
    }
    
    
    func bindUserEnroll() {
        let userList = detailModel?.user_list
        if userList != nil {
            for  userModel in userList! {
                if userModel.uid == CurrentUserHelper.shared.userInfo.uid {
                    enroolButtonHeightConstraint.constant = 0
                    enrollButton.enabled = false;
                    return
                }
            }
        }
        enroolButtonHeightConstraint.constant = 49
        enrollButton.enabled = true;
    }
    
    func didEnrollComplete(resultInt:Int!) {
        //0-活动已结束 1-报名成功 2-之前已报名
        switch resultInt {
        case 0:
            SVProgressHUD.showErrorWithStatus("活动已结束")
        case 1:
            SVProgressHUD.showSuccessWithStatus("报名成功")
            fallthrough
        case 2:
            let userModel = UserModel()
            userModel.uid = CurrentUserHelper.shared.userInfo.uid
            userModel.head_url = CurrentUserHelper.shared.userInfo.head_url
            detailModel?.entry_num += 1
            detailModel?.user_list.insert(userModel, atIndex: 0)
            didRequestComplete(detailModel)//先整表刷新
        default:
            break
        }
    }
    
    @IBAction func didActionEnroll(sender: AnyObject) {
        enrollButton.enabled = false;
        AppAPIHelper.skillShareAPI().enroll(share_id, uid: CurrentUserHelper.shared.userInfo.uid, complete: { [weak self](resultInt) in
            self?.didEnrollComplete(resultInt as? Int);
            }, error: errorBlockFunc())
    }
    
}
