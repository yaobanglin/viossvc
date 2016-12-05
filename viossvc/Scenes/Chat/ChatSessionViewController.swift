//
//  ChatSessionViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class ChatSessionViewController: BaseTableViewController,ChatSessionsProtocol {
    internal var dataSource = [ChatSessionModel]();
    private var chatSessionHelper:ChatSessionHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatSessionHelper = ChatSessionHelper(chatSessionsDelegate: self)
        ChatMsgHepler.shared.chatSessionHelper = chatSessionHelper
    }
    
    
    func updateChatSessions(chatSession:[ChatSessionModel]) {
        dataSource = chatSession
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
        chatSessionHelper.chatSessionsDelegate = nil
        ChatMsgHepler.shared.chatSessionHelper = nil
    }

}
