//
//  SettingsView.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/1/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("photoPrismServerAddress") private var photoPrismServerAddress: String = ""
    @AppStorage("photoPrismUser") private var photoPrismUser: String = ""
    @AppStorage("photoPrismPassword") private var photoPrismPassword: String = ""
    @AppStorage("backupOnCellular") private var backupOnCellular: Bool = false
    @AppStorage("backupOnBattery") private var backupOnBattery: Bool = false

    private var passwordTitle: String = "Password"
    @State private var isSecured: Bool = true
    
    var body: some View {
        List {
            Section("PhotoPrism") {
                TextField("Server Address", text: $photoPrismServerAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                TextField("User", text: $photoPrismUser)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                HStack {
                    Group {
                        if isSecured {
                            SecureField(passwordTitle, text: $photoPrismPassword)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                        } else {
                            TextField(passwordTitle, text: $photoPrismPassword)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                        }
                    }.padding(.trailing, 32)

                    Button(action: {
                        isSecured.toggle()
                    }) {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                            .accentColor(.gray)
                    }
                }
            }
            Section("Backups") {
                Toggle("On Cellular", isOn: $backupOnCellular)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                Toggle("On Battery", isOn: $backupOnBattery)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
