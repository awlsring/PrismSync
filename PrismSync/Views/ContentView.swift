//
//  ContentView.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 6/30/23.
//

import SwiftUI
import Photos
import SQLite3
import Blackbird

struct ContentView: View {
    @BlackbirdLiveModels({ try await MediaDb.read(from: $0, orderBy: .ascending(\.$id)) }) var sentPhotos
    @StateObject var mediaLibrary = MediaLibrary()
    
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var selectedCount = 0
    @State private var selectableItems: [String: Bool] = [:]
    
    func uploadPhotos() {
        
    }
    
    private func initializeSelectedItems(_ mediaList: [MediaModel]) {
        selectedCount = mediaList.count
        for item in mediaList {
            selectableItems[item.id] = true
        }
    }

    private func updateSelectedCount() {
        selectedCount = selectableItems.filter { $0.value }.count
    }
    
    var body: some View {
        let mediaList = mediaLibrary.listMedia()
        
        VStack {
            
            VStack {
                HStack {
                    Text("Total: \(mediaLibrary.itemAmount())").padding([.horizontal])
                    Spacer()
                    Text("Selected: \(selectedCount)").padding([.horizontal])
                }
                ScrollView {
                    LazyVGrid(columns: gridColumns) {
                        ForEach(mediaList) { item in
                            if !$sentPhotos.results.contains(where: { $0.id == item.id }) {
                                GeometryReader { geo in
                                    GridItemView(size: geo.size.width, item: item, selected: Binding(
                                        get: {
                                            selectableItems[item.id] ?? false
                                        },
                                        set: { newValue in
                                            selectableItems[item.id] = newValue
                                            updateSelectedCount()
                                        }
                                    ))
                                }
                                .cornerRadius(8.0)
                                .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                }.padding()
            }
            .navigationTitle("Images")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                initializeSelectedItems(mediaList)
            }
            
            HStack {
                Button(action: uploadPhotos, label: {
                    HStack {
                        Image(systemName: "arrow.up")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        Text("Upload")
                        
                    }
                })
                Spacer()
                Button(action: mediaLibrary.refresh, label: {
                    HStack {
                        Image(systemName: "arrow.up")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        Text("Refresh")
                    }
                }).padding([.horizontal])
            }
        }
        .padding()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
////        let prismClient = PhotoPrismClient(baseURL: URL(string: "https://tmp.com/")!, username: "admin", password: "tmp")
//        
////        let photos = PhotoController.shared()
//        
//        ContentView()
//    }
//}
