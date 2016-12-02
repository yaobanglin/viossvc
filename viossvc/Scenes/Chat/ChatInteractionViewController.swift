//
//  ChatInteractionViewController.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ChatInteractionViewController: BaseCustomPageListTableViewController {

    @IBOutlet weak var inputBar: InputBarView!
    @IBOutlet weak var inputBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var inputBarBottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func didRequest(pageIndex: Int) {
        let model = ChatModel()
        model.content = "adad我我奥多姆拉丁名"
        
        let modelMe = ChatModel()
        modelMe.content = "adladlmclcmlamlacnancla"
        modelMe.from_uid = CurrentUserHelper.shared.uid
        
     didRequestComplete([model,modelMe])
        
    }

  override  func isCalculateCellHeight() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, cellIdentifierForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let model = self.tableView(tableView, cellDataForRowAtIndexPath: indexPath) as! ChatModel
        
        
        return  model.from_uid == CurrentUserHelper.shared.uid ? "ChatWithISayCell" : "ChatWithAnotherSayCell"
    }
    
    
  
}

