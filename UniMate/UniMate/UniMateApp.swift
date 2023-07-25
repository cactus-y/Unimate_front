//
//  UniMateApp.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct UniMateApp: App {
    @StateObject private var appStateManager = AppStateManager()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            if appStateManager.isLoggedIn || Auth.auth().currentUser != nil {
                MainTabView()
                    .environmentObject(appStateManager)
            } else {
                LoginView()
                    .environmentObject(appStateManager)
            }
            
        }
    }
}
