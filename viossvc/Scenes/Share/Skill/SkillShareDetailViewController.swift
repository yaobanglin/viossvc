//
//  SkillShareDetailViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class SkillShareDetailViewController: BaseCustomRefreshTableViewController,OEZTableViewDelegate {
    
    var share_id:Int = 0
    var model:SkillShareDetailModel?
    @IBOutlet weak var bannerView: CommTableViewBannerCell!
    var chatView:UIView? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame:CGRect = bannerView.frame
        frame.size.height = UIScreen.mainScreen().bounds.width*185.0/375.0
        bannerView.frame = frame
        tableView.tableHeaderView = bannerView
//        bannerView.update(["test3","test1","test3","test1","test3","test1"]);
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
        return model
    }
    
    //MARK: -UITableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model != nil ? 4 : 0
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
        AppAPIHelper.skillShareAPI().detail(share_id, complete: { [weak self] (model) in
                self?.didRequestComplete(model)
            }, error: errorBlockFunc())
    }
    
    override func didRequestComplete(data: AnyObject?) {
        model = data as? SkillShareDetailModel;
        if model != nil && model!.detail_pic != nil {
            bannerView.update([model!.detail_pic]);
        }
        super.didRequestComplete(data);
    }

}
