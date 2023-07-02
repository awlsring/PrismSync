//
//  NoAuthView.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/1/23.
//

import SwiftUI
import Photos

struct NoAuthView: View {
    @Binding var needsAuth: Bool
    @State var message: String = "I need access"
    var checkAuth: () -> Void
    
    private func checkHandler() {
        checkAuth()
        message = "Rechecked and still no access. Try closing and reopening."
    }
    
    var body: some View {
        VStack {
            Text(message).padding().multilineTextAlignment(.center)
            Button(action: checkHandler) {
                Text("Recheck authorization")
            }
            .padding()
            .buttonStyle(BorderedButtonStyle())
        }
    }
}
