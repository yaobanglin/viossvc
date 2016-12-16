//
//  SegmentedViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

@objc protocol SegmentedViewControllerProtocol {
    optional func segmentedViewController(index:Int) -> UIViewController?;
    optional func segmentedViewControllerIdentifiers() -> [String]!;
}

class SegmentedViewController: UIViewController , SegmentedViewControllerProtocol {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private var courrentShowController:UIViewController? = nil;
    private var dictViewControllers:Dictionary<Int,UIViewController!> = Dictionary<Int,UIViewController!>();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        initSegmentedControl();
        reloadViewControllers();
        
    }
    
    
    
    final func reloadViewControllers() {
        for(_,viewController) in dictViewControllers {
            viewController.willMoveToParentViewController(nil);
            viewController.removeFromParentViewController();
        }
        dictViewControllers.removeAll();
        segmentedControl.sendActionsForControlEvents(.ValueChanged);
    }
    
    func contentRect() -> CGRect {
        var rect:CGRect =  view.frame;
        rect.origin.y = 0.0;
        return rect;
    }
    
    final func didActionChangeValue(sender: AnyObject) {
        if sender.isKindOfClass(UISegmentedControl) {
            showViewController(segmentedControl.selectedSegmentIndex);
        }
    }
    
    final func showViewController(index:Int) {
        segmentedControl.selectedSegmentIndex = index;
        _showViewController(getViewControllerAtIndex(index));
    }
    
    final func _showViewController(viewController:UIViewController?) {
        if viewController != nil {
            if courrentShowController != nil {
                segmentedControl.userInteractionEnabled = false
                self.transitionFromViewController(courrentShowController!, toViewController: viewController!, duration: 0.1, options: .CurveEaseInOut, animations: nil, completion: { (Bool) in
                    if Bool {
                        self.segmentedControl.userInteractionEnabled = true
                        viewController?.didMoveToParentViewController(self);
                        self.courrentShowController = viewController!;
                    }
                });
            }
            else {
                self.courrentShowController = viewController!;
                view .addSubview(viewController!.view);
            }
        }
        
    }
    
    final func getViewControllerAtIndex(index:Int) -> UIViewController? {
        var viewController:UIViewController? = dictViewControllers[index];
        if viewController == nil {
            viewController = createViewController(index);
            if viewController != nil  {
                dictViewControllers[index] = viewController;
                addChildViewController(viewController!);
                viewController!.view.frame = contentRect();
            }
        }
        return viewController;
    }
    
    final func createViewController(index:Int) -> UIViewController? {
        let svcProtocol:SegmentedViewControllerProtocol = self as SegmentedViewControllerProtocol;
        if( svcProtocol.segmentedViewController != nil ) {
            return svcProtocol.segmentedViewController?(index);
        }
        
        if( svcProtocol.segmentedViewControllerIdentifiers != nil ) {
            let identifiers:[String]! = svcProtocol.segmentedViewControllerIdentifiers!();
            return  storyboard?.instantiateViewControllerWithIdentifier(identifiers[index]);
        }
        
        return nil;
    }
    
    private func initSegmentedControl() {
        
        let textAttr = [NSForegroundColorAttributeName:UIColor.whiteColor()/*,NSFontAttributeName:UIFont.systemFontOfSize(15)*/];
        segmentedControl.setTitleTextAttributes(textAttr, forState: UIControlState.Normal);
        segmentedControl.setTitleTextAttributes(textAttr, forState: UIControlState.Selected);
        
        segmentedControl.addTarget(self, action: #selector(didActionChangeValue(_:)), forControlEvents:.ValueChanged);
    }
    
    
}

