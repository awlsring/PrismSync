//
//  AlbumImageView.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/2/23.
//

import SwiftUI
import PhotosUI

struct AlbumImageView: View {
    let index: Int
    let asset: PHAsset
    let size: CGFloat
    @Binding var selectedItems: Set<Int>
    @State private var image: UIImage = UIImage()

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .cornerRadius(8)
            .padding([.horizontal])
            .onAppear {
                fetchImage()
            }
            .overlay(
                selectedItems.contains(index) ?
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .opacity(0.7)
                        .offset(x: size/2 - 5, y: size/2 - 5)
                    : nil
            )
    }

    private func fetchImage() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false

        manager.requestImage(for: asset, targetSize: CGSize(width: size, height: size), contentMode: .aspectFill, options: options) { result, _ in
            if let result = result {
                image = result
            }
        }
    }
}
