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
    
    var photosArray:[NSData?] = []
    
    var seletedPhotosArray:[Int] = []
    
    var photoImages:[UIImage?] = []
    
    var timer:NSTimer?
    
    var theLastIndexPath:NSIndexPath?
    
    let preloadNum = 300
    
    deinit {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        view.backgroundColor = UIColor.whiteColor()
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let width = (screenWidth - 35.0) / 4.0
        layout.estimatedItemSize = CGSizeMake(width, width)
        layout.sectionInset.left = 5
        layout.sectionInset.top = 5
        layout.sectionInset.right = 5
        layout.sectionInset.bottom = 5
        layout.headerReferenceSize = CGSizeMake(screenWidth, 30)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        collectionView?.registerClass(PhotoCollectionCell.self, forCellWithReuseIdentifier: "PhotoCollectionCell")
        collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PhotoCollectionHeader")
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
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
                thumb!.append(UIImage.init(data: (photosArray[index])!)!)
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
    
    func getPhotoHD(index: Int, completed: (AnyObject?) ->()) {
        if index < photosAsset!.count {
            let asset = photosAsset![index%photosAsset!.count] as! PHAsset
            let options:PHImageRequestOptions = PHImageRequestOptions()
            options.version = .Current
            options.deliveryMode = .FastFormat
            options.networkAccessAllowed = true
            options.resizeMode = .Fast
            PHImageManager.defaultManager().requestImageDataForAsset(asset, options: options, resultHandler: { (data, uti, orientation, info) in
                if data != nil {
                    dispatch_async(dispatch_get_global_queue(0, 0), { () in
                        self.photosArray[index] = data!
                        completed(index)
                    })
                }
            })
        }
    }
    
    func getPhotoThumb(index: Int, feture: Bool) {
        if index < photosAsset!.count {
            let asset = photosAsset![index%photosAsset!.count] as! PHAsset
            let options:PHImageRequestOptions = PHImageRequestOptions()
            options.version = .Current
            options.deliveryMode = .FastFormat
            options.networkAccessAllowed = true
            options.resizeMode = .Fast
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeZero, contentMode: .AspectFit, options: options, resultHandler: { (result, info) in
                if self.photoImages[index] == nil {
                    self.photoImages[index] = result!
                    if self.photoImages.count > 30 {
                        if index == 30 {
                            if !feture {
                                dispatch_async(dispatch_get_main_queue(), { () in
                                    self.collectionView?.reloadData()
                                })
                            }
                        } else if (!feture || index - self.theLastIndexPath!.row < 30) && index > self.preloadNum {
                            dispatch_async(dispatch_get_main_queue(), { () in
                                self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                            })
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () in
                            self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                        })
                    }
                } else {
                    if index == 30 {
                        if !feture {
                            dispatch_async(dispatch_get_main_queue(), { () in
                                self.collectionView?.reloadData()
                            })
                        }
                    } else {
                        if index - self.theLastIndexPath!.row < 30 {
                            dispatch_async(dispatch_get_main_queue(), { () in
                                self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath.init(forItem: index, inSection: 0)])
                            })
                        }
                    }
                }
            })
        }
    }

    func initPhotos() {
        let all = PHFetchOptions()
        all.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        photosAsset = PHAsset.fetchAssetsWithMediaType(.Image, options: all)
        photosArray = Array.init(count: photosAsset!.count, repeatedValue: nil)
        photoImages = Array.init(count: photosAsset!.count, repeatedValue: nil)
        if preloadNum > 0 {
            for i in 0..<(photoImages.count > preloadNum ? preloadNum : photoImages.count) {
                self.getPhotoThumb(i, feture: i > 32 ? true : false)
            }
        } else {
            if photoImages.count > 120 {
                for i in 0..<120 {
                    self.getPhotoThumb(i, feture: i > 32 ? true : false)
                }
                dispatch_async(dispatch_get_global_queue(0, 0), { () in
                    for i in 120..<self.photoImages.count {
                        self.getPhotoThumb(i, feture: i > 32 ? true : false)
                    }
                })
            } else {
                for i in 0..<photoImages.count {
                    self.getPhotoThumb(i, feture: i > 32 ? true : false)
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
        return photosAsset?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        theLastIndexPath = indexPath
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionCell" ,forIndexPath: indexPath) as? PhotoCollectionCell {
            cell.type = .UnSelect
            cell.delegate = self
            if seletedPhotosArray.contains(indexPath.row) {
                cell.type = .Selected
            }
            if photoImages[indexPath.row] != nil {
                cell.updateWithImage(photoImages[indexPath.row]!, indexPath: indexPath)
            } else {
                if let data = photosArray[indexPath.row] {
                    photoImages[indexPath.row] = compress(data)
                    cell.updateWithImage(photoImages[indexPath.row]!, indexPath: indexPath)
                } else {
                    getPhotoThumb(indexPath.row, feture: false)
                }
            }
            if preloadNum > 0 {
                if indexPath.row + preloadNum < photoImages.count {
                    if photoImages[indexPath.row + preloadNum] == nil {
                        getPhotoThumb(indexPath.row + preloadNum, feture: true)
                    }
                }
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let data = photosArray[indexPath.row] {
            PhotoPreviewView.showLocal(UIImage.init(data: data)!)
        } else {
            weak var weakSelf = self
            if let img = photoImages[indexPath.row] {
                PhotoPreviewView.showLocal(img)
                getPhotoHD(indexPath.row, completed: { (index) in
                    PhotoPreviewView.update(UIImage.init(data: weakSelf!.photosArray[indexPath.row]!)!)
                })
            }
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
                cell.type = .Selected
                weak var weakSelf = self
                getPhotoHD(indexPath!.row, completed: { (index) in
                    weakSelf?.seletedPhotosArray.append(indexPath!.row)
                })
            }
            cell.update()
            headerTitle?.text = "还能选择\(8 - seletedPhotosArray.count)张照片"
        }
    }
    
    func compress(imageData: NSData) ->UIImage? {
        if imageData.length / 1024 > 16 {
            NSLog("\(imageData.length / 1024)")
            let srcImg = UIImage.init(data: imageData)
            let imgWidth = srcImg!.size.width
            let imgHeight = srcImg!.size.height
            let width:CGFloat = 120
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
    
    override func didReceiveMemoryWarning() {
        
    }
    
}

