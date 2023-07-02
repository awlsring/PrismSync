//import SwiftUI
//import PhotosUI
//import Photos
//
//import Foundation
//
//struct GridView: View {
//    
//    @EnvironmentObject var mediaLibrary: MediaLibrary
//    private static let initialColumns = 3
//    @State private var isAddingPhoto = false
//    @State private var isEditing = false
//
//    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
//    @State private var numColumns = initialColumns
//
//    private var columnsTitle: String {
//        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
//    }
//
//    var body: some View {
//        VStack {
//            if isEditing {
//                Stepper(title: columnsTitle, range: 1...8, columns: $gridColumns)
//                .padding()
//            }
//
//            ScrollView {
//                LazyVGrid(columns: gridColumns) {
//                    ForEach(mediaLibrary.items) { item in
//                        GeometryReader { geo in
//                            NavigationLink {
//                                GridItemView(size: geo.size.width, item: item)
//                            }
//                        }
//                        .cornerRadius(8.0)
//                        .aspectRatio(1, contentMode: .fit)
//                        .overlay(alignment: .topTrailing) {
//                            if isEditing {
//                                Button {
//                                    withAnimation {
//                                        mediaLibrary.removeItem(item)
//                                    }
//                                } label: {
//                                    Image(systemName: "xmark.square.fill")
//                                                .font(Font.title)
//                                                .symbolRenderingMode(.palette)
//                                                .foregroundStyle(.white, .red)
//                                }
//                                .offset(x: 7, y: -7)
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationBarTitle("Image Gallery")
//        .navigationBarTitleDisplayMode(.inline)
//        .sheet(isPresented: $isAddingPhoto) {
//            PhotosPicker("pick")
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(isEditing ? "Done" : "Edit") {
//                    withAnimation { isEditing.toggle() }
//                }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    isAddingPhoto = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//                .disabled(isEditing)
//            }
//        }
//    }
//}
//
//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView().environmentObject(MediaLibrary())
//            .previewDevice("iPad (8th generation)")
//    }
//}
