//
//  ChatSessionViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class ChatListViewController: BaseTableViewController,ChatSessionsProtocol {
    internal var dataSource = [ChatSessionModel]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChatSessions()
        ChatSessionHelper.shared.chatSessionsDelegate = self
    }
    
    
    func updateChatSessions() {
        dataSource = ChatSessionHelper.shared.chatSessions
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        return dataSource[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
                    let viewController:ChatInteractionViewController = storyboardViewController()
                    viewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    deinit {
        ChatSessionHelper.shared.chatSessionsDelegate = nil
    }

}
