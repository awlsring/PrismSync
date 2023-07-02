//
//  PrismSyncApp.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 6/30/23.
//

import SwiftUI
import Blackbird

@main
struct PrismSyncApp: App {
    @StateObject var database = try! Blackbird.Database.inMemoryDatabase()

    var body: some Scene {
        WindowGroup {
            Main()
            .environment(\.blackbirdDatabase, database)
            .preferredColorScheme(.dark)
        }
    }
}
