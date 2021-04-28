//
//  RITLPhotosBrowserAllDataSource.swift
//  RITLImagePicker-Swift
//
//  Created by YueWen on 2021/4/27.
//  Copyright © 2021 YueWen. All rights reserved.
//

import UIKit
import Photos

/// 游览所有数据的数据源
public final class RITLPhotosBrowserAllDataSource: NSObject, RITLPhotosBrowserDataSource {

    /// 进入预览组的集合
    var collection = PHAssetCollection() {
        didSet {
            assetResult = PHAsset.fetchAssets(in: collection, options: nil)
        }
    }
    /// 当前点击进入的资源对象
    var asset = PHAsset()
    /// 存储资源的对象
    private(set) var assetResult = PHFetchResult<PHAsset>()
    /// 资源化的manager
    private(set) var imageManager: PHCachingImageManager = PHCachingImageManager()
    
    
    //MARK: RITLPhotosBrowserDataSource
    func asset(at indexPath: IndexPath) -> PHAsset? {
        guard indexPath.item < assetResult.count else { return nil }
        return assetResult.object(at: indexPath.item)
    }
    
    func defaultIndexPath() -> IndexPath {
        guard assetResult.contains(asset) else { return IndexPath(item: 0, section: 0) }
        return IndexPath(item: assetResult.index(of: asset), section: 0)
    }
}

extension RITLPhotosBrowserAllDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}