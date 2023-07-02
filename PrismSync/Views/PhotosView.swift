//
//  PhotosView.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/1/23.
//

import SwiftUI
import PhotosUI

struct PhotosView: View {
    @State private var albums: [Album] = []
    
    var body: some View {
        List(albums) { album in
            NavigationLink(destination: AlbumView(album: album)) {
                HStack {
                    if let thumbnailImage = album.thumbnailImage {
                        Image(uiImage: thumbnailImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text(album.name)
                }
                .padding([.vertical])
            }
        }
        .navigationTitle("Photos")
        .onAppear {
            fetchAlbums()
        }
    }
    func fetchAlbums() {
        let fetchOptions = PHFetchOptions()
        let albumFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        let smartAlbumFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        let topLevelUserCollectionsFetchResult = PHCollectionList.fetchTopLevelUserCollections(with: fetchOptions)

        let allAlbums = [albumFetchResult, smartAlbumFetchResult, topLevelUserCollectionsFetchResult]
            .compactMap { $0 as? PHFetchResult<PHCollection> }
            .flatMap { $0.objects(at: IndexSet(0..<($0.count))) }

        var fetchedAlbums: [Album] = []
        allAlbums.forEach { collection in
            let name = collection.localizedTitle ?? ""
            let thumbnailImage = fetchThumbnailImage(for: collection)
            fetchedAlbums.append(Album(name: name, thumbnailImage: thumbnailImage, collection: collection))
        }

        albums = fetchedAlbums
    }

    func fetchThumbnailImage(for collection: PHCollection) -> UIImage? {
        guard let albumCollection = collection as? PHAssetCollection else {
            return nil
        }

        let options = PHFetchOptions()
        options.fetchLimit = 1
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult = PHAsset.fetchAssets(in: albumCollection, options: options)
        guard let firstAsset = fetchResult.firstObject else {
            return nil
        }

        let opts = PHImageRequestOptions()
        opts.isSynchronous = true
        opts.deliveryMode = .highQualityFormat

        var thumbnailImage: UIImage?
        PHImageManager.default().requestImage(for: firstAsset, targetSize: CGSize(width: 40, height: 40), contentMode: .aspectFit, options: opts) { image, _ in
            thumbnailImage = image
        }

        return thumbnailImage
    }
}


struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
