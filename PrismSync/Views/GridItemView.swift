import SwiftUI
import Photos
import Blackbird

struct GridItemView: View {
    let size: Double
    let item: MediaModel
    @Binding var selected: Bool
    
    var onSelectionChanged: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                selected.toggle()
                onSelectionChanged?()
                
            }, label: {
                Image(uiImage: item.toUIImage())
                    .frame(width: size, height: size)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(self.selected ? Color.yellow : Color.black, lineWidth: 6))
            })
        }
    }
    
    func toggleSelect() {
        self.selected = !selected
    }
}
