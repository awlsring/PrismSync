//
//  MediaDbModel.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 6/30/23.
//

import Foundation
import Blackbird

struct MediaDb: BlackbirdModel {
    @BlackbirdColumn var id: String
    @BlackbirdColumn var filename: String
    @BlackbirdColumn var sentAt: Int64
}
