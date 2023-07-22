//
//  MainTabView.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        NavigationView {
            TabView {
                BoardView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                
                LeaderBoardView()
                    .tabItem {
                        Image(systemName: "list.clipboard")
                    }
                
                MessageView()
                    .tabItem {
                        Image(systemName: "paperplane")
                    }
                
                NotificationView()
                    .tabItem {
                        Image(systemName: "bell")
                    }
                
                UserView()
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
