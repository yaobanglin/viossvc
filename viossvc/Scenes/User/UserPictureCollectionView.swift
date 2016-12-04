//
//  UserPictureCollectionView.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class UserPictureItem: UICollectionViewCell {
    @IBOutlet weak var userPicture: UIImageView!
    
}


class UserPictureCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var picturesData: [PhotoModel]?
    var itemHeight: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let layout = UICollectionViewFlowLayout()
        itemHeight = (UIScreen.width() - 32) / 4
        layout.itemSize = CGSizeMake(itemHeight, itemHeight)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        collectionViewLayout = layout
        delegate = self
        dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturesData == nil ? 0 : picturesData!.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item: UserPictureItem = collectionView.dequeueReusableCellWithReuseIdentifier(UserPictureItem.className(), forIndexPath: indexPath) as! UserPictureItem
        let model = picturesData![indexPath.row]
        item.userPicture.kf_setImageWithURL(NSURL.init(string: model.thumbnail_url!), placeholderImage: UIImage.init(named: "head_boy"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        return item
    }
    
    func updateMyPicture(data: AnyObject, complete: CompleteBlock?) {
        picturesData = data as? [PhotoModel]
        reloadData()
        if complete != nil {
            let rows = picturesData!.count / 4
            let height = itemHeight * (rows == 1 ? CGFloat(rows) : CGFloat(rows + 1) )
            complete!(height)
        }
    }
    
}
