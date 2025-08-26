//
//  SettingsView.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 15.08.2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(\.dismiss) private var dismiss
    @State private var userName: String = ""
    
    var body: some View {
        @Bindable var navigationManager = navigationManager

        if navigationManager.userName == navigationManager.defaultUserName {
            Text("Hello \(navigationManager.defaultUserName)\n")
            Text("Seems you didn't set your name yet.")
            Text("You can do it down below.")
        }else {
            Text("Hello \(navigationManager.userName)")
        }
        
//        Form {
            
            TextField("Enter your name here", text: $userName)
            .autocorrectionDisabled()
            .padding()
            .textFieldStyle(.roundedBorder)
//        }
        MyEqualWidthHstack {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.trailing)
            Button {
                if !userName.isEmpty {
                    navigationManager.userName = userName
                }
                dismiss()
            } label: {
                Text("Ok")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.leading)
        }
    }
}

#Preview {
    SettingsView()
        .environment(NavigationManager())
}
