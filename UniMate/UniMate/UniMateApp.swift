//
//  UniMateApp.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/21.
//

import SwiftUI
import Firebase

@main
struct UniMateApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            LoginView()
        }
    }
}
