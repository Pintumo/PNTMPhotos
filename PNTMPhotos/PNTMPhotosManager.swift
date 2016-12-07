//
//  PNTMPhotosManager.swift
//  PNTMPhotos
//
//  Created by Evangelos Sismanidis on 06.12.16.
//  Copyright © 2016 Pintumo. All rights reserved.
//

import Foundation
import Photos

public class PNTMPhotosManager {

    let collectionQueue = DispatchQueue.init(label: "CollectionQueue")
    var album: PHFetchResult<PHAssetCollection> = PHFetchResult()

    init() {
    }
    
    convenience init(ForAlbum album: String) {
        self.init()
        
        self.album = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [ album ], options: nil)
    }
    
    public func allPhotos() -> PHFetchResult<PHAsset> {
        
        if  let album = self.album.firstObject {
            return PHAsset.fetchAssets(in: album, options: nil)
        } else {
            return PHFetchResult()
        }
    }
}
