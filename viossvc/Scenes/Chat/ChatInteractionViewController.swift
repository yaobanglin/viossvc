//
//  ChatInteractionViewController.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
class ChatInteractionViewController: BaseCustomListTableViewController,InputBarViewProcotol,ChatSessionProtocol{


    @IBOutlet weak var inputBar: InputBarView!
    @IBOutlet weak var inputBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var inputBarBottom: NSLayoutConstraint!
    var chatSession:ChatSessionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
       inputBar.registeredDelegate(self)
        self.title = chatSession.title
        ChatSessionHelper.shared.openChatSession(self)
       
    }
    
    
    func receiveMsg(chatMsgModel: ChatMsgModel) {
        
    }
    
    func sessionUid() -> Int {
       return chatSession.sessionId
    }
    
    override func didRequest() {
   
        

        let model = ChatMsgModel()
        model.content = "adad我我奥多姆拉丁名"
        
        let modelMe = ChatMsgModel()
        modelMe.content = "adladlmclcmlamlacnancla"
        modelMe.from_uid = CurrentUserHelper.shared.uid
        
        var array = [ChatMsgModel]()
        for i  in 0 ... 9 {
            let model = ChatMsgModel()
            model.content = "按揭款打底裤" + "\(arc4random() % 10)"  + " 圣诞节疯狂" + "\(i)" + (i % 3 > 1 ? "andadnl 案例及大量的 到家了的" : "莱文斯基")
            model.from_uid = arc4random() % 3 == 1 ? CurrentUserHelper.shared.uid : 123
            array.append(model)
            
        }
        
        
        
     didRequestComplete(array)
        
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
     
        print(message)
    }
    func inputBarDidChangeHeight(inputBar inputBar: InputBarView, height: CGFloat) {
   
        
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

