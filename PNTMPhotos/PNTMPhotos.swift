//
//  PNTMPhotos.swift
//  PNTMPhotos
//
//  Created by Evangelos Sismanidis on 07.12.16.
//  Copyright © 2016 Pintumo. All rights reserved.
//

import Foundation
import Photos

public class PNTMPhotos {
    
    var collection: PHAssetCollection!
    var placeholder: PHObjectPlaceholder!
    
    public init(withAlbum album: String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", album)
        var collectionOptional = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if let collection = collectionOptional.firstObject {
            self.collection = collection
        } else {
            
            PHPhotoLibrary.shared().performChanges({
                let createCollectionRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: album)
                self.placeholder = createCollectionRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { (success, error) in
                if success {
                    collectionOptional = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.placeholder.localIdentifier], options: nil)
                    if let collection = collectionOptional.firstObject {
                        self.collection = collection
                    } else {
                        assert(false, "Album creation request failed")
                    }
                }
                else {
                    assert(false, "Album creation request failed")
                }
            })
        }
    }
    
    public func all() -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(in: collection, options: nil)
    }
    
    public func save(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.collection) else {
                assert(false, "Album change request failed")
                return
            }

            guard let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
                assert(false, "Placeholder is nil")
                return
            }
            self.placeholder = photoPlaceholder
            albumChangeRequest.addAssets([ self.placeholder ]  as NSArray)
        }, completionHandler: { success, error in
        })
    }
    
    public func select(index: NSInteger, width: CGFloat) -> UIImage {
        var image : UIImage!
        PHImageManager.default().requestImage(for: self.all()[index],
                                              targetSize: CGSize(width: width, height: 0.75 * width),
                                              contentMode: .aspectFill,
                                              options: nil) { (result, info) in
                                                image = result!
        }
        
        return image
    }
}
