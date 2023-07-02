//
//  Album.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/2/23.
//

import Foundation
import PhotosUI

struct Album: Identifiable {
    let id = UUID()
    let name: String
    let thumbnailImage: UIImage?
    let collection: PHCollection
}
