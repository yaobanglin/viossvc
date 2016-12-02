//
//  PhotoWallUploadViewController.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

class PhotoWallUploadViewController: UICollectionViewController, PhotoSelectorViewControllerDelegate, PhotoCollectionCellDelegate {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var photosArray:[UIImage]? = []
    
    var seletedPhotosArray:[Int] = []
    
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
            let uid = CurrentUserHelper.shared.userInfo.uid
            weak var weakSelf = self
            for (index, img) in photosArray!.enumerate() {
                let name = "thumb"
                qiniuUploadImage(img, imagePath: "\(uid)/PhotoWall/", imageName: name, index: index, complete: { [weak self](response) in
                    let imageUrl = response![1] as! String
                    if imageUrl != "failed" {
                        NSLog("===>upload2qiniu: %d", index)
                        var list:[[String: String]] = []
                        list.append(["thumbnail_url_": imageUrl])
                        let dict:[String: AnyObject] = ["uid_": uid, "photo_list_": list]
                        AppAPIHelper.userAPI().uploadPhoto2Wall(dict, complete: { (response) in
                            NSLog("===>uploaded2server: \(index)")
//                            if cnt == 8 {
//                                weakSelf!.navigationController?.popViewControllerAnimated(true)
//                            }
                        }, error: { (error) in
                            NSLog("\(error)")
                        })
                    }
                })
                
            }
            
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
            cell.type = .CanRemove
            cell.delegate = self
            if indexPath.row < photosArray!.count {
                cell.updateWithImage(photosArray![indexPath.row], indexPath: indexPath)
            } else {
                cell.updateWithImage(UIImage.init(named: "balance")!, indexPath: indexPath)
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
            seletedPhotosArray.removeAtIndex(indexPath!.row)
            photosArray?.removeAtIndex(indexPath!.row)
            collectionView?.reloadData()

        }
    }
    
    //MARK: - PhotoSelectorViewController
    func selected(thumb: [UIImage]?, src: [UIImage]?, seletedIndex: [Int]) {
        photosArray = thumb
        seletedPhotosArray = seletedIndex
    }
    
}