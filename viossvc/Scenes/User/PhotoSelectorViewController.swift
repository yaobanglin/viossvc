//
//  PhotoSelectorViewController.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation
import Photos

protocol PhotoSelectorViewControllerDelegate: NSObjectProtocol {
    
    func selected(thumb:[UIImage]? ,src:[UIImage]?, seletedIndex:[Int])
    
}

class PhotoSelectorViewController: UICollectionViewController, PHPhotoLibraryChangeObserver, PhotoCollectionCellDelegate {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    var headerTitle:UILabel?
    
    var photosArray:[UIImage]? = []
    
    var seletedPhotosArray:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
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
        getAllPhotos()
        
    }
    
    func rightItemTapped() {
        var thumb:[UIImage]? = []
        if seletedPhotosArray.count > 0 {
            for index in seletedPhotosArray {
                thumb!.append(photosArray![index])
            }
            delegate?.selected(thumb, src: nil, seletedIndex: seletedPhotosArray)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func initNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .Plain, target: self, action: #selector(rightItemTapped))
    }
    
    func getAllPhotos() {
        let all = PHFetchOptions()
        all.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let assets = PHAsset.fetchAssetsWithMediaType(.Image, options: all)
        let screenBounds = UIScreen.mainScreen().bounds
        for i in 0..<assets.count {
            let asset = assets[i]
            let options:PHImageRequestOptions = PHImageRequestOptions()
            options.version = PHImageRequestOptionsVersion.Current
            PHImageManager.defaultManager().requestImageForAsset(asset as! PHAsset, targetSize: CGSizeMake(screenBounds.width, screenBounds.height), contentMode: .AspectFill, options: options) {
                (result, objects) -> Void in
                if result == nil {
                    return 
                }
                self.photosArray?.append(result!)
                if i == assets.count - 1 {
                    self.collectionView?.reloadData()
                }
            }

        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "PhotoCollectionHeader", forIndexPath: indexPath)
        
        headerTitle = header.viewWithTag(1001) as? UILabel
        if headerTitle == nil {
            headerTitle = UILabel()
            headerTitle?.frame = CGRectMake(20, 15, 300, 15)
            headerTitle?.tag = 1001
            headerTitle?.backgroundColor = UIColor.clearColor()
            headerTitle?.text = "还能选择\(8 - seletedPhotosArray.count)张照片"
            headerTitle?.textColor = UIColor.grayColor()
            headerTitle?.font = UIFont.systemFontOfSize(15)
            header.addSubview(headerTitle!)
        }
        
        return header
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionCell" ,forIndexPath: indexPath) as? PhotoCollectionCell {
            cell.type = .UnSelect
            cell.delegate = self
            if seletedPhotosArray.contains(indexPath.row) {
                cell.type = .Selected
            }
            let asset = photosArray![indexPath.row]
            cell.updateWithImage(asset, indexPath: indexPath)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("%d", indexPath.row)
        
        PhotoPreviewView.showLocal(photosArray![indexPath.row])
    }
    
    //MARK: - PH
    func photoLibraryDidChange(changeInstance: PHChange) {
        getAllPhotos()
        collectionView?.reloadData()
    }
    
    //MARK: - PhotoCollectionCellDelegate
    func rightTopButtonAction(indexPath: NSIndexPath?) {
        if let cell = collectionView!.cellForItemAtIndexPath(indexPath!) as? PhotoCollectionCell {
            if let index = seletedPhotosArray.indexOf(indexPath!.row) {
                seletedPhotosArray.removeAtIndex(index)
                cell.type = .UnSelect
            } else {
                seletedPhotosArray.append(indexPath!.row)
                cell.type = .Selected
            }
            cell.update()
            headerTitle?.text = "还能选择\(8 - seletedPhotosArray.count)张照片"
        }
    }
}

