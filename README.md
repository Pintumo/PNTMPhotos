![image](PNTMPhotosLogo.png)

PNTMPhotos is a small library which handles just a basic amount of features regarding Apples PHPhotolibrary.

PNTMPhotos is build on top of RxSwift. Currently PNTMPhotos handles only three cases.

Get all images from a Photo Collection of your choice, select on image from the collection and save one imagae to the collection.

### Installation

PNTMPhotos currently only supports Cocoapods. Add

`pod 'PNTMPhotos', :git =>  'https://github.com/Pintumo/PNTMPhotos.git'`

to your Podfile and run

`pod install`


### Usage

Checkout `AppDelegate.swift`

```
let photos = PNTMPhotos(withAlbum: "PNTMPhotos")
        
_ = photos.save(image: UIImage(named: "PNTMPhotosLogo")!).subscribe(onNext: { saved in
   print(saved)
})
        
_ = photos.select(index: 0, size: CGSize(width: 100, height: 100), contentMode: .aspectFit).subscribe(onNext: { image in
   print(image)
})
        
_ = photos.all().subscribe(onNext: { assets in
   print(assets.count)
})

```

### Attention

This Lib needs access to your Photos, don't forget to include the Privacy - Photo Library Usage Description (NSPhotoLibraryUsageDescription) Key in your Info.plist when using this Lib. Otherwise iOS 10 won't be very happy when starting your app.
