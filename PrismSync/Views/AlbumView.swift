//
//  AlbumView.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/2/23.
//

import SwiftUI
import Photos

struct AlbumView: View {
    let album: Album
    @State private var selectedItems: Set<Int> = []
    @State private var photos: [PHAsset] = []

    var body: some View {
        HStack {
            Text("Total: \(photos.count)").padding([.horizontal])
            Spacer()
        }
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 10) {
                ForEach(photos.indices, id: \.self) { index in
                    AlbumImageView(index: index, asset: photos[index], size: gridItemSize, selectedItems: $selectedItems)
                        .onTapGesture {
                            selectItem(index)
                        }
                }
            }
            .padding()
        }
        .navigationTitle(album.name)
        .onAppear {
            fetchPhotos()
        }
        .overlay(
            Text("Selected Items: \(selectedItems.count)")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
                .opacity(selectedItems.isEmpty ? 0 : 0.8)
        )
    }
    
    private func selectItem(_ index: Int) {
        if selectedItems.contains(index) {
            selectedItems.remove(index)
        } else {
            selectedItems.insert(index)
        }
    }

    private var gridLayout: [GridItem] {
        let gridItemSize: CGFloat = 100
        let spacing: CGFloat = 10
        let itemCount = UIScreen.main.bounds.width / (gridItemSize + spacing)
        let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: Int(itemCount))
        return columns
    }

    private var gridItemSize: CGFloat {
        let spacing: CGFloat = 10
        let itemCount: CGFloat = 3
        let availableWidth = UIScreen.main.bounds.width - spacing * (itemCount - 1)
        let itemSize = availableWidth / itemCount
        return itemSize - 10
    }

    private func fetchPhotos() {
        guard let albumCollection = album.collection as? PHAssetCollection else {
            return
        }

        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult = PHAsset.fetchAssets(in: albumCollection, options: options)

        var fetchedPhotos: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            fetchedPhotos.append(asset)
        }

        photos = fetchedPhotos
    }
}
