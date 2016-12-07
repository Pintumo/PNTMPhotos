//
//  PNTMPhotos.swift
//  PNTMPhotos
//
//  Created by Evangelos Sismanidis on 07.12.16.
//  Copyright © 2016 Pintumo. All rights reserved.
//

import Foundation
import Photos
import RxSwift

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
    
    public func save(image: UIImage) -> Observable<Bool> {
        return Observable.create() { observer in
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
                
                if (error != nil) {
                    observer.on(.next(true))
                    observer.on(.completed)
                } else {
                    observer.on(.error(error!))
                }
                
        })
            return Disposables.create()
        }
    }
    
    
    
    public func select(index: NSInteger, size: CGSize, contentMode: PHImageContentMode) -> Observable<UIImage> {
        return Observable.create() { observer in
            PHImageManager.default().requestImage(for: self.all()[index], targetSize: size, contentMode: contentMode, options: nil) { (result, info) in
                if let image = result {
                    observer.on(.next(image as UIImage))
                    observer.on(.completed)
                } else {
                    observer.on(.error(RxError.unknown))
                }
            }
            return Disposables.create()
        }
    }
}
