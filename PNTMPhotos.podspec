Pod::Spec.new do |s|


  s.name         = "PNTMPhotos"
  s.version      = "0.0.3"
  s.summary      = "PNTMPhotos is a light weight interface to PHPhotoLibrary."

  s.description  = <<-DESC

  PNTMPhotos is a wrapper around the PHPhotoLibrary and will contain only
  a little amaount of featuresi.

  it is build on top of RxSwift

                   DESC

  s.homepage     = "https://github.com/Pintumo/PNTMPhotos"

  s.license      = "MIT"

  s.author             = { "Evangelos Sismanidis" => "evangelos@posteo.eu" }

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/Pintumo/PNTMPhotos.git", :tag => "#{s.version}" }

  s.dependency 'RxSwift'

  s.source_files  = "PNTMPhotos", "PNTMPhotos/*.{swift}"


	
end
