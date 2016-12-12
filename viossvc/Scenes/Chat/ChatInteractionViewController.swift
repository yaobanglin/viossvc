//
//  ChatInteractionViewController.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import XCGLogger

private let  sectionHeaderHeight : CGFloat  = 50.0
class ChatInteractionViewController: BaseCustomListTableViewController,InputBarViewProcotol,ChatSessionProtocol{

    let  showTime  = 300
  

    @IBOutlet weak var inputBar: InputBarView!
    @IBOutlet weak var inputBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var inputBarBottom: NSLayoutConstraint!
    var chatUid:Int = 0
    var chatName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       inputBar.registeredDelegate(self)
        self.title = chatName
        ChatSessionHelper.shared.openChatSession(self)
        updateUserInfo()
        didRequest()
        settingTableView()

    }
    
    func settingTableView() {
       tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tableView.registerClass(ChatSectionView.classForCoder(), forHeaderFooterViewReuseIdentifier: "ChatSectionView")
        tableView.tableHeaderView = UIView(frame:CGRectMake(0,0,0,0.5))
        

    }
    
    override func autoRefreshLoad() -> Bool {
        return false
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
       let pageSize = 20
       let offset = dataSource == nil ? 0 : dataSource!.count
       var array = ChatMsgHepler.shared.findHistoryMsg(chatUid, offset: offset , pageSize: pageSize) as [AnyObject]
        if array.count <  pageSize {
            removeRefreshControl()
        }
        
        if dataSource != nil {
            array.appendContentsOf(dataSource!)
        }
        
        didRequestComplete(array)
        if offset == 0 {
//            _tableViewScrolToBottom(false)
            
            self.performSelector(#selector(self.tableViewScrolToBottom), withObject: nil, afterDelay: 0.1)
        }
    }
    
    
    

  override  func isCalculateCellHeight() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        var datas:[AnyObject]? = dataSource;
        return  (datas != nil && datas!.count > indexPath.section ) ? datas![indexPath.section] : nil;
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource == nil ? 0 : dataSource!.count
    }
    
    override func tableView(tableView: UITableView, cellIdentifierForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let model = self.tableView(tableView, cellDataForRowAtIndexPath: indexPath) as! ChatMsgModel
        
        
        return  model.from_uid == CurrentUserHelper.shared.uid ? "ChatWithISayCell" : "ChatWithAnotherSayCell"
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return  isTimeToShow(section) ? sectionHeaderHeight : 0.1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.backgroundColor = UIColor.clearColor()
//    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView : ChatSectionView?
        if isTimeToShow(section) {
            let model = self.tableView(tableView, cellDataForRowAtIndexPath: NSIndexPath.init(forRow: 0, inSection: section)) as! ChatMsgModel
            headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("ChatSectionView") as? ChatSectionView
            headerView?.update(model)
        }
       return headerView
        
    }
    
    func isTimeToShow(index : Int) -> Bool {
        var  isShow = false
        if dataSource != nil {
            if index == 0 {
                isShow = true
            }else {
                let currentModel = dataSource![index] as!  ChatMsgModel
                let beforeModel = dataSource![index - 1] as! ChatMsgModel
                isShow = currentModel.msg_time - beforeModel.msg_time >= showTime
            }
        }
        
        return isShow
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
        _tableViewScrolToBottom(true)
        
    }
    func inputBarChangeHeight(height : CGFloat) {
        inputBarBottom.constant = height
        self.view.layoutIfNeeded()
        if height > 0 {
           _tableViewScrolToBottom(false)
        }
    }
    
    func tableViewScrolToBottom() {
        
        if  dataSource?.count > 0 {
            
            tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: dataSource!.count - 1), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    func _tableViewScrolToBottom(animated : Bool? = true){
        
        if  dataSource?.count > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: dataSource!.count - 1), atScrollPosition: UITableViewScrollPosition.Top, animated: animated!)
        }
  
        
    }
    deinit {

        ChatSessionHelper.shared.closeChatSession()
    }
  
}

 class ChatSectionView: UITableViewHeaderFooterView,OEZUpdateProtocol {
//    var label : UILabel = UILabel()
    let layerLeft : CALayer = CALayer()
    let layerRight : CALayer = CALayer()
    let stringLabel = UILabel.init()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let color = AppConst.Color.C3
        layerLeft.backgroundColor = color.CGColor
        layerRight.backgroundColor = color.CGColor
        self.layer.addSublayer(layerLeft)
        self.layer.addSublayer(layerRight)
        
        stringLabel.textAlignment = .Center
        stringLabel.font = UIFont.SIZE(11)
        stringLabel.textColor = color
        stringLabel.frame = CGRectMake(0, 0, UIScreen.width(), sectionHeaderHeight)
        self.addSubview(stringLabel)
        
        
        
    }
    
    
    
    func update(data: AnyObject!) {
        let  model = data as! ChatMsgModel
        let string = model.formatMsgTime() as NSString
        
         stringLabel.text = string as String
        
        let strWidth =   string.sizeWithAttributes([NSFontAttributeName : UIFont.SIZE(11)]).width
        let width = UIScreen.width() - 50 - strWidth
        let layerWidth = width > 120 ? 60 : (width - 20) / 2.0
        let startX = (UIScreen.width() - strWidth - 50 - 2 * layerWidth) / 2.0
        layerLeft.frame = CGRectMake(startX, (sectionHeaderHeight - 0.5) / 2.0, layerWidth, 0.5)
        layerRight.frame = CGRectMake(startX + layerWidth + strWidth  + 50, (sectionHeaderHeight - 0.5) / 2.0, layerWidth, 0.5)
        
    }
    
//    init(frame: CGRect,model: ChatMsgModel) {
//       super.init(reuseIdentifier: "ChatSectionView")
//        
//       let  label = detailTextLabel!
////        self.addSubview(label)
//        label.textAlignment = .Center
//        label.font = UIFont.SIZE(11)
//        label.textColor = AppConst.Color.C3
//        let string = model.formatMsgTime() as NSString
//        
//        label.text  = string as String
//        
//        let  strWidth =   string.sizeWithAttributes([NSFontAttributeName : UIFont.SIZE(11)]).width
//        let width = UIScreen.width() - 50 - strWidth
//        let layerWidth = width > 120 ? 60 : (width - 20) / 2.0
//        
//        let layer1 = CALayer()
//        layer1.backgroundColor = AppConst.Color.C3.CGColor
//        
//        let startX = (UIScreen.width() - strWidth - 50 - 2 * layerWidth) / 2.0
//        layer1.frame = CGRectMake(startX, (frame.height - 0.5) / 2.0, layerWidth, 0.5)
//        
//        let layer2 = CALayer()
//        layer2.backgroundColor = AppConst.Color.C3.CGColor
//        
//        layer2.frame = CGRectMake(startX + layerWidth + strWidth  + 50, (frame.height - 0.5) / 2.0, layerWidth, 0.5)
//        
//        self.layer.addSublayer(layer1)
//        self.layer.addSublayer(layer2)
//        
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

