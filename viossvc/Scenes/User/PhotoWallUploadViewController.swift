//
//  PhotoWallUploadViewController.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation
import SVProgressHUD


class PhotoWallUploadViewController: UICollectionViewController, PhotoSelectorViewControllerDelegate, PhotoCollectionCellDelegate {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var photosArray:[UIImage]? = []
    
    var seletedPhotosArray:[Int] = []
    
    var uploaded:[Int: [String: String]] = [:]
    
    var doneIndex:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let width = (screenWidth - 75.0) / 4.0
        layout.estimatedItemSize = CGSizeMake(width, width)
        layout.sectionInset.left = 20
        layout.sectionInset.top = 20
        layout.sectionInset.right = 20
        layout.sectionInset.bottom = 20
        layout.headerReferenceSize = CGSizeMake(screenWidth, 30)
        
        collectionView?.registerClass(PhotoCollectionCell.self, forCellWithReuseIdentifier: "PhotoCollectionCell")
        collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PhotoCollectionHeader")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initNav()
        collectionView?.reloadData()
    }
    
    func initNav() {
        if navigationItem.rightBarButtonItem == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .Plain, target: self, action: #selector(rightItemTapped))
        }
        
    }
    
    func rightItemTapped() {
        if photosArray?.count > 0 {
            SVProgressHUD.showProgressMessage(ProgressMessage: "照片上传中...")
            let uid = CurrentUserHelper.shared.userInfo.uid
            var reUp = true
            for (index, img) in photosArray!.enumerate() {
                let done = doneIndex.indexOf(index)
                if done == nil {
                    qiniuUploadImage(img, imagePath: "\(uid)/PhotoWall/", imageName: "photo", tags: ["index": index], complete: { [weak self] (response) in
                            self!.upload2Server(response)
                        })
                    reUp = false
                }
            }
            if reUp {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func upload2Server(response: AnyObject?) {
        if let resp = response as? [AnyObject] {
            let uid = CurrentUserHelper.shared.userInfo.uid
            let imageUrl = resp[1] as! String
            let tags = resp[0] as? [String: Int]
            let index = tags!["index"]!
            if imageUrl != "failed" {
                uploaded[index] = ["thumbnail_url_": imageUrl + "?imageView2/2/w/80/h/80/interlace/0/q/100"]
                uploaded[index]?.updateValue(imageUrl, forKey: "photo_url_")
                doneIndex.append(index)
                let dict:[String: AnyObject] = ["uid_": uid, "photo_list_": [uploaded[index] as! AnyObject]]
                AppAPIHelper.userAPI().uploadPhoto2Wall(dict, complete: completeBlockFunc(), error: { (error) in
                    NSLog("\(error)")
                })
            } else {
                SVProgressHUD.showErrorMessage(ErrorMessage: "图片 \(index) 上传出错，请重试", ForDuration: 1, completion: nil)
            }
        }
        
    }
    
    func completeBlockFunc()->CompleteBlock {
        return { [weak self] (obj) in
            self?.didRequestComplete(obj)
        }
    }
    
    func didRequestComplete(data:AnyObject?) {
        collectionView?.reloadData()
        if doneIndex.count == seletedPhotosArray.count {
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "PhotoCollectionHeader", forIndexPath: indexPath)
        
        var title = header.viewWithTag(1001) as? UILabel
        if title == nil {
            title = UILabel()
            title?.frame = CGRectMake(20, 15, 300, 15)
            title?.tag = 1001
            title?.backgroundColor = UIColor.clearColor()
            title?.text = "最多只能同时上传8张照片"
            title?.textColor = UIColor.grayColor()
            title?.font = UIFont.systemFontOfSize(15)
            header.addSubview(title!)
        }
        
        return header
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray!.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionCell" ,forIndexPath: indexPath) as? PhotoCollectionCell {
            cell.delegate = self
            if indexPath.row < photosArray!.count {
                if let _ = doneIndex.indexOf(indexPath.row) {
                    cell.type = .Selected
                } else {
                    cell.type = .CanRemove
                }
                cell.updateWithImage(photosArray![indexPath.row], indexPath: indexPath)
            } else {
                cell.updateWithImage(UIImage.init(named: "tianjia")!, indexPath: indexPath)
                cell.type = .Normal
            }
            cell.update()
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("%d", indexPath.row)
        if indexPath.row == photosArray!.count {
            if let photoSelector = storyboard?.instantiateViewControllerWithIdentifier("PhotoSelectorViewController") as? PhotoSelectorViewController {
                photoSelector.delegate = self
                photoSelector.seletedPhotosArray = self.seletedPhotosArray
                navigationController?.pushViewController(photoSelector, animated: true)
            }
            
        }
    }
    
    //MARK: - PhotoCollectionCellDelegate
    func rightTopButtonAction(indexPath: NSIndexPath?) {
        if indexPath != nil {
            if let cell = collectionView?.cellForItemAtIndexPath(indexPath!) as? PhotoCollectionCell {
                if cell.type == .CanRemove {
                    seletedPhotosArray.removeAtIndex(indexPath!.row)
                    photosArray?.removeAtIndex(indexPath!.row)
                    collectionView?.reloadData()
                }
            }
            
        }
    }
    
    //MARK: - PhotoSelectorViewController
    func selected(thumb: [UIImage]?, src: [UIImage]?, seletedIndex: [Int]) {
        photosArray = thumb
        seletedPhotosArray = seletedIndex
    }
    
}
