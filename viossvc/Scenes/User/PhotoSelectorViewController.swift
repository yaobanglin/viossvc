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
    
    var photosAsset:PHFetchResult?
    
    var photosArray:[AnyObject]? = []
    
    var seletedPhotosArray:[Int] = []
    
    var photoImages:[UIImage?] = []
    
    var timer:NSTimer?
    
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
        
        initPhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initNav()
        collectionView?.reloadData()
    }
    
    func rightItemTapped() {
        var thumb:[UIImage]? = []
        if seletedPhotosArray.count > 0 {
            for index in seletedPhotosArray {
                thumb!.append(UIImage.init(data: (photosArray![index] as? NSData)!)!)
            }
            delegate?.selected(thumb, src: nil, seletedIndex: seletedPhotosArray)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func initNav() {
        if navigationItem.rightBarButtonItem == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .Plain, target: self, action: #selector(rightItemTapped))
        }
        
    }
    
    func getPhoto(index: Int) {
        if index < photosAsset!.count {
            let asset = photosAsset![index] as! PHAsset
            let options:PHImageRequestOptions = PHImageRequestOptions()
            options.version = .Current
            options.deliveryMode = .Opportunistic
            options.networkAccessAllowed = true
            weak var weakSelf = self
            PHImageManager.defaultManager().requestImageDataForAsset(asset, options: options, resultHandler: { (data, uti, orientation, info) in
                if data != nil {
                    dispatch_async(dispatch_get_global_queue(0, 0), { () in
                        weakSelf?.photosArray![index] = data!
                        if weakSelf?.photoImages[index] == nil {
                            weakSelf?.photoImages[index] = weakSelf?.compress(data!)
                            dispatch_async(dispatch_get_main_queue(), { () in
                                weakSelf?.collectionView?.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                            })
                        }
                    })
                }
            })
        }
    }

    func initPhotos() {
        let all = PHFetchOptions()
        all.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: all)
        photosArray = Array.init(count: photosAsset!.count, repeatedValue: UIImage())
        photoImages = Array.init(count: photosAsset!.count, repeatedValue: nil)
        collectionView?.reloadData()
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
        return photosAsset?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionCell" ,forIndexPath: indexPath) as? PhotoCollectionCell {
            cell.type = .UnSelect
            cell.delegate = self
            if seletedPhotosArray.contains(indexPath.row) {
                cell.type = .Selected
            }
            if photoImages[indexPath.row] != nil {
                cell.updateWithImage(photoImages[indexPath.row]!, indexPath: indexPath)
            } else {
                getPhoto(indexPath.row)
                cell.photo?.image = UIImage.init(named: "head_giry")
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("%d", indexPath.row)
        
        if let data = photosArray![indexPath.row] as? NSData {
            PhotoPreviewView.showLocal(UIImage.init(data: data)!)
        }
        
    }
    
    //MARK: - PH
    func photoLibraryDidChange(changeInstance: PHChange) {
        initPhotos()
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
    
    func compress(imageData: NSData) ->UIImage? {
        if imageData.length / 1024 > 128 {
            let srcImg = UIImage.init(data: imageData)
            let imgWidth = srcImg!.size.width
            let imgHeight = srcImg!.size.height
            let width:CGFloat = 160
            let height = imgHeight / (imgWidth / width)
            let widthScale = imgWidth / width
            let heightScala = imgHeight / height
            
            UIGraphicsBeginImageContext(CGSizeMake(width, height))
            if widthScale > heightScala {
                srcImg?.drawInRect(CGRectMake(0, 0, imgWidth / heightScala, height))
            } else {
                srcImg?.drawInRect(CGRectMake(0, 0, width, imgHeight / widthScale))
            }
            let dstImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return dstImg
        }
        return UIImage.init(data: imageData)
    }
    
}

