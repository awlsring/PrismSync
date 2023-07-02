//
//  MediaModel.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 6/30/23.
//

import Foundation
import SwiftUI
import Photos
import Blackbird

struct MediaModel: Identifiable {
    let id: String
    let asset: PHAsset
    let filename: String
    let fileType: PHAssetResourceType
    let mediaType: PHAssetMediaType
    
    
    
    init(asset: PHAsset) {
        self.asset = asset
        let resource = PHAssetResource.assetResources(for: asset).first!
        self.id = asset.localIdentifier
        self.filename = resource.originalFilename
        self.mediaType = asset.mediaType
        self.fileType = resource.type
    }

    func toData() -> Data {
        let options = PHImageRequestOptions()
        options.version = .original
        var d = Data()
        PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
            if data != nil {
                d = data!
            }
        }
        return d
    }
    

    func toUIImage() -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}

extension MediaModel: Equatable {
    static func ==(lhs: MediaModel, rhs: MediaModel) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
