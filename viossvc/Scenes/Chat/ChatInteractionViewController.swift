//
//  ChatInteractionViewController.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import XCGLogger
class ChatInteractionViewController: BaseCustomListTableViewController,InputBarViewProcotol,ChatSessionProtocol{




    @IBOutlet weak var inputBar: InputBarView!
    @IBOutlet weak var inputBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var inputBarBottom: NSLayoutConstraint!
    var chatUid:Int = 0
    var chatName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
       inputBar.registeredDelegate(self)
        self.title = chatName
        ChatSessionHelper.shared.openChatSession(self)
        updateUserInfo()
        
    }
    
    private func updateUserInfo() {
        if chatUid != 0 {
            AppAPIHelper.userAPI().getUserInfo(chatUid, complete: { [weak self](model) in
                  let userInfo = model as? UserInfoModel
                    if userInfo != nil {
                        self?.title = userInfo!.nickname
                        ChatSessionHelper.shared.didReqeustUserInfoComplete(userInfo!)
                    }
                }, error:nil)
        }
        
    }
    
    func receiveMsg(chatMsgModel: ChatMsgModel) {
        
        dataSource?.append(chatMsgModel)
        tableView.reloadData()
       tableViewScrolToBottom()
    }
    
    func sessionUid() -> Int {
       return chatUid
    }
    
    override func didRequest() {
     let id = dataSource == nil || dataSource?.count == 0 ? 0 : (dataSource?.first as! ChatMsgModel).id
       var array = ChatMsgHepler.shared.findHistoryMsg(chatUid, lastId: id , pageSize: 20) as [AnyObject]
        if array.count == 0 {
            removeRefreshControl()
        }
        
        if dataSource != nil {
            array.appendContentsOf(dataSource!)
        }
        
        didRequestComplete(array)
        if id == 0 {
            
            tableViewScrolToBottom()
        }
    }
    
    
    

  override  func isCalculateCellHeight() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, cellIdentifierForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let model = self.tableView(tableView, cellDataForRowAtIndexPath: indexPath) as! ChatMsgModel
        
        
        return  model.from_uid == CurrentUserHelper.shared.uid ? "ChatWithISayCell" : "ChatWithAnotherSayCell"
    }
    
    
    
    
    
    
    
    
    
    
    func inputBarDidKeyboardHide(inputBar inputBar: InputBarView, userInfo: [NSObject : AnyObject]?) {
        let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        let rawValue = (userInfo![UIKeyboardAnimationCurveUserInfoKey]?.integerValue)! << 16
        let curve = UIViewAnimationOptions.init(rawValue: UInt(rawValue))
        

      
        UIView.animateWithDuration(duration!, delay: 0, options: curve, animations: {
            [weak self]() in
            self!.inputBarChangeHeight(-1)
            }, completion: nil)


        
    }
    
    func inputBarDidKeyboardShow(inputBar inputBar: InputBarView, userInfo: [NSObject : AnyObject]?) {
        
        let  height =  CGRectGetHeight(userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue())
        if (height > 0) {
            
            let heightTime = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            
            
            UIView.animateWithDuration(heightTime, animations: {
                 [weak self]() in
                self!.inputBarChangeHeight(height)
                
            })

        }
        
    }
    

    
    func inputBarDidSendMessage(inputBar inputBar: InputBarView, message: String) {
        if !message.isEmpty {
            ChatMsgHepler.shared.sendMsg(chatUid, msg: message)
        }
    }
    func inputBarDidChangeHeight(inputBar inputBar: InputBarView, height: CGFloat) {
        inputBarHeight.constant = height;
        self.view.layoutIfNeeded()
        tableViewScrolToBottom()
        
    }
    func inputBarChangeHeight(height : CGFloat) {
        inputBarBottom.constant = height
        self.view.layoutIfNeeded()
        if height > 0 {
           tableViewScrolToBottom()
        }
    }
    
    func tableViewScrolToBottom() {
        
        if  dataSource?.count > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: dataSource!.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    deinit {

        ChatSessionHelper.shared.closeChatSession()
    }
  
}

