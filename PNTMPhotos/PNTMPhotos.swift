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
    
    let collectionName : String
    
    public init(withAlbum album: String) {
        collectionName = album
    }
    
    public func all() -> Observable<PHFetchResult<PHAsset>> {
        return collection().map { collection in
            PHAsset.fetchAssets(in: collection, options: nil)
        }
    }
    
    public func save(image: UIImage) -> Observable<Bool> {
        return collection()
            .flatMap { collection in
                Observable.create() { observer in
                    var placeholder: PHObjectPlaceholder!
                    PHPhotoLibrary.shared().performChanges({
                        let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        
                        guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: collection) else {
                            observer.on(.error(RxError.unknown))
                            return;
                        }
                        
                        guard let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
                            observer.on(.error(RxError.unknown))
                            return;
                        }
                        placeholder = photoPlaceholder
                        
                        albumChangeRequest.addAssets([ placeholder ]  as NSArray)
                        
                    }, completionHandler: { success, error in
                        
                        if (error == nil) {
                            observer.on(.next(true))
                            observer.on(.completed)
                        } else {
                            observer.on(.error(error!))
                        }
                    })
                    return Disposables.create()
                }
        }
    }
    
    public func select(index: uint, size: CGSize, contentMode: PHImageContentMode) -> Observable<UIImage> {
        return all()
            .filter({ $0.count > 0})
            .flatMap { assets in
                Observable.create() { observer in
                    PHImageManager.default().requestImage(for: assets[Int(index)], targetSize: size, contentMode: contentMode, options: nil) { (result, info) in
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
}


// Private Helpers

extension PNTMPhotos {
    func collection() -> Observable<PHAssetCollection> {
        return Observable.create() { observer in
            var placeholder: PHObjectPlaceholder!
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", self.collectionName)
            var collectionOptional = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let collection = collectionOptional.firstObject {
                observer.on(.next(collection))
                observer.on(.completed)
            } else {
                PHPhotoLibrary.shared().performChanges({
                    let createCollectionRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.collectionName)
                    placeholder = createCollectionRequest.placeholderForCreatedAssetCollection
                }, completionHandler: { (success, error) in
                    if success {
                        collectionOptional = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                        if let collection = collectionOptional.firstObject {
                            observer.on(.next(collection))
                            observer.on(.completed)
                        } else {
                            observer.on(.error(RxError.unknown))
                        }
                    }
                    else {
                        observer.on(.error(RxError.unknown))
                    }
                })
            }
            return Disposables.create()
        }
    }
}
