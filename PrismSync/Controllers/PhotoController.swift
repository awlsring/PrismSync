//
//  PhotoController.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 6/30/23.
//

import Foundation
import Photos
import PhotosUI
import SwiftUI

class PhotoController {
    private static var sharedPhotoController: PhotoController = {
        let controller = PhotoController()
        return controller
    }()
    
    class func shared() -> PhotoController {
        return sharedPhotoController
    }
    private var media: [String: MediaModel] = [:]
    private let prismClient: PhotoPrismClient
    
    private init() {
        self.prismClient =  PhotoPrismClient(baseURL: URL(string: "https://tmp.com/")!, username: "admin", password: "tmp")
        self.loadPhotoLibrary()
    }
    
    func test() -> PHFetchResult<PHCollection> {
        return PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }
    
    private func addMediaToLibrary(asset: PHAsset) {
        let mediaModel = MediaModel(asset: asset)
        print("Adding asset \(mediaModel)")

        self.media[mediaModel.id] = mediaModel
    }
    
    func getMediaDict() -> [String: MediaModel] {
        return self.media
    }
    
    func listMedia() -> [MediaModel] {
        return Array(self.media.values)
    }
    
    func getMedia(id: String) throws -> MediaModel {
        guard let media = self.media[id] else {
            throw NSError(domain: "PhotoController", code: 1, userInfo: ["message": "Media not found"])
        }
        return media
    }
    
    func loadPhotoLibrary() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        var total = 0
        assets.enumerateObjects { (ass, index, stop) in
            total = total + 1
            self.addMediaToLibrary(asset: ass)
        }
        print("Total photos: \(total)")
    }

    func getImageFromPrism(location:String, id: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        prismClient.getPhoto(location: location, photoID: id) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(PhotoPrismClientError.resourceNotFound))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func uploadPhoto(asset: PHAsset) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        var imageData: Data?
        
        option.isSynchronous = true
        manager.requestImageData(for: asset, options: option) { (data, _, _, _) in
            imageData = data
            if data != nil {
                
                print(asset)
                let resource = PHAssetResource.assetResources(for: asset).first!
                print(resource)
                
                self.prismClient.uploadPhoto(location: "originals/PhotoSync", photoID: resource.originalFilename, imageData: data!) { result in
                    print(result)
                    switch result {
                    case .success(_):
                        print("Uploaded photo")
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
}
