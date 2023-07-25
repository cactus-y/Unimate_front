//
//  AppStateManager.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/25.
//

import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var isLoggedIn = false
}
