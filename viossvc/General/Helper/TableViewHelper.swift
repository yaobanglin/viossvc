//
//  TableViewHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/11/1.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

protocol TableViewHelperProtocol {
    //获取Cell ReuseIdentifier
    func tableView(tableView:UITableView ,cellIdentifierForRowAtIndexPath indexPath: NSIndexPath) -> String?;
    //获取Cell数据
    func tableView(tableView:UITableView ,cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject?;
    //是否从cell类中计算高度，默认false
    func isCalculateCellHeight() -> Bool;
    //是否缓存cell高度，默认false,当为true时,cell类中计算高度自动打开
    func isCacheCellHeight() -> Bool;
    //是否为多组方式取数据,默认false
    func isSections() ->Bool;
}

//#MARK: -TableViewHelper
class TableViewHelper {
   private var cacheCellClasss:Dictionary<String,AnyClass> = Dictionary<String,AnyClass>();
   private var classCellNoFountCalculateHeights:Array<String> = Array<String>();
   private var cacheCellHeights:Dictionary<NSIndexPath,CGFloat> = Dictionary<NSIndexPath,CGFloat>();
    

    //默认ReuseIdentifier前缀
    var defaultCellIdentifier:String? = nil;
    
    //默认ReuseIdentifier前缀+Cell,多组时section非0前缀+Cell+section
    func tableView<T:UIViewController where T:TableViewHelperProtocol>(tableView:UITableView ,cellIdentifierForRowAtIndexPath indexPath: NSIndexPath,controller:T) -> String? {
        if( defaultCellIdentifier == nil ) {
            defaultCellIdentifier = controller.classForCoder.className();
            for  target:String in ["ViewController","Controller"] {
                if defaultCellIdentifier!.hasSuffix(target) {
                    defaultCellIdentifier = defaultCellIdentifier?.stringByReplacingOccurrencesOfString(target, withString: "");
                    break;
                }
            }
            defaultCellIdentifier?.appendContentsOf("Cell");
        }
        return indexPath.section != 0 ? defaultCellIdentifier! + String(indexPath.section) : defaultCellIdentifier;
    }
    
    func tableView<T:UIViewController where T:TableViewHelperProtocol>(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath,controller:T) -> UITableViewCell {
        let identifier:String? = controller.tableView(tableView, cellIdentifierForRowAtIndexPath: indexPath);
        return tableView.dequeueReusableCellWithIdentifier(identifier!, forIndexPath: indexPath);
    }
    
    func tableView<T:UIViewController where T:TableViewHelperProtocol>(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath,controller:T) {
        if cell.conformsToProtocol(OEZUpdateProtocol)  {
            (cell as! OEZUpdateProtocol).update(controller.tableView(tableView, cellDataForRowAtIndexPath: indexPath));
        }
    }
    
    func calculateCellHeight<T:UIViewController where T:TableViewHelperProtocol>(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath,controller:T) -> CGFloat {
        let identifier:String? = controller.tableView(tableView,cellIdentifierForRowAtIndexPath:indexPath);
        var cellClass:AnyClass? = nil;
        if identifier != nil {
            cellClass = cacheCellClasss[identifier!];
            if cellClass == nil {
                if( !classCellNoFountCalculateHeights.contains(identifier!) ) {
                    cellClass =  NSClassFromString("viossvc."+identifier!);
                    if cellClass != nil && cellClass!.conformsToProtocol(OEZCalculateProtocol)
                        && cellClass!.calculateHeightWithData != nil {
                        cacheCellClasss[identifier!] = cellClass!;
                    }
                    else {
                        classCellNoFountCalculateHeights.append(identifier!);
                        cellClass = nil;
                    }
                }
            }
        }
        return cellClass == nil ? CGFloat.max : cellClass!.calculateHeightWithData(controller.tableView(tableView, cellDataForRowAtIndexPath: indexPath));
    }
    
    
    func tableView<T:UIViewController where T:TableViewHelperProtocol>(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath,controller:T) -> CGFloat {
        var cellHeight:CGFloat? = cacheCellHeight(indexPath);
        if !controller.isCacheCellHeight() || cellHeight == nil {
            cellHeight = calculateCellHeight(tableView, heightForRowAtIndexPath: indexPath, controller: controller);
            if controller.isCacheCellHeight() && cellHeight != CGFloat.max {
                cacheCellHeights[indexPath] = cellHeight;
            }
        }
        return cellHeight!;
    }
    
    
    func didRequestComplete<T:UIViewController where T:TableViewHelperProtocol>(inout dataSource:Array<AnyObject>?,pageDatas:Array<AnyObject>?,controller:T) {
        if controller.pageIndex == 1 {
            dataSource = pageDatas;
        }
        else {
            if( pageDatas?.count > 0 ) {
                dataSource?.appendContentsOf(pageDatas!)
                controller.endLoadMore();
            }
            else {
                controller.notLoadMore();
            }
        }
        controller.setIsLoadData(true);
    }
    // MARK: - cacheCellClass
    func addCacheCellClass<T:UITableViewCell>(type:T.Type,cellIdentifier:String) {
        cacheCellClasss[cellIdentifier] = type;
    }
    
    // MARK: - CacheCellHeight
    func removeCacheCellHeight(indexPath: NSIndexPath) ->Bool {
        return cacheCellHeights.removeValueForKey(indexPath) != nil;
    }
    
    func removeCacheCellHeights(indexPaths:Array<NSIndexPath>)  {
        for indexPath in indexPaths {
            removeCacheCellHeight(indexPath);
        }
    }
    
    func addCacheCellHeight(height:CGFloat , indexPath: NSIndexPath)  {
        cacheCellHeights[indexPath] = height;
    }
    
    func removeAllCacheCellHeight() {
        cacheCellHeights.removeAll();
    }
    
    func cacheCellHeight(indexPath: NSIndexPath) -> CGFloat? {
        return cacheCellHeights[indexPath];
    }

}