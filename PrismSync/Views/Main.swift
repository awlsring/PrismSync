//
//  Main.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/1/23.
//

import SwiftUI
import Photos

struct Main: View {
    var isPreview: Bool = false
    
    @State var needsAuth: Bool = false
    
    private func checkPhotoLibraryAuthorization() {
        if isPreview {
            print("Is preview")
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.needsAuth = false
        default:
            self.needsAuth = true
        }
    }
    
    var body: some View {
        VStack {
            NavigationView {
                if needsAuth {
                    NoAuthView(needsAuth: $needsAuth, checkAuth: checkPhotoLibraryAuthorization)
                } else {
                    List {
                        Section {
                            NavigationLink("Photos", destination: ContentView()).padding([.vertical])
                            NavigationLink("Activity", destination: ActivityView()).padding([.vertical])
                        }
                        Section {
                            NavigationLink("Settings", destination: SettingsView()).padding([.vertical])
                        }
                    }
                    .navigationTitle("PrismSync")
                }
            }
            
        }
        .onAppear {
            self.checkPhotoLibraryAuthorization()
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main(isPreview: true, needsAuth: false)
    }
}
