//
//  UserPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
            }
            .navigationTitle("내 정보")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
