//
//  MediaLibrary.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 6/30/23.
//

import Foundation
import Blackbird
import Photos
import PhotosUI

class MediaLibrary: ObservableObject {
    @Published var items: [String: MediaModel] = [:]
    
    init() {
        self.refresh()
    }
    
    func refresh() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        var total = 0
        assets.enumerateObjects { (ass, index, stop) in
            total = total + 1
            self.addToMedia(asset: ass)
        }
    }
    
    func addToMedia(asset: PHAsset) {
//        if sentPhotos.results.contains { $0.id == asset.localIdentifier } {
//            print("Item is in DB, ignoring")
//            return
//        }
        if items[asset.localIdentifier] == nil {
            print("Item isn't in map, adding")
            let m = MediaModel(asset: asset)
            items[m.id] = m
        }
    }

    func getMedia(id: String) throws -> MediaModel {
        guard let media = self.items[id] else {
            throw NSError(domain: "PhotoController", code: 1, userInfo: ["message": "Media not found"])
        }
        return media
    }
    
    func itemAmount() -> Int {
        return items.count
    }

    func listMedia() -> [MediaModel] {
        return Array(self.items.values)
    }

}
