//
//  ReloadButtonView.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 22.08.2025.
//

import SwiftUI

struct ReloadButtonView: View {
//    @Environment(\.refresh) private var refresh
//    @StateObject private var refreshPerformer = CustomeRefreshPerformer()
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(\.managedObjectContext) private var viewContext
    var myAction: () -> Void
    
    var body: some View {
        HStack {
            Button("Reload through naviManager", action: {
                navigationManager.refreshTest()
                myAction()
            })
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ReloadButtonView(myAction: {})
        .environment(NavigationManager())
}
