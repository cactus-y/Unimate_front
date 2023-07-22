//
//  NotificationPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
            }
            .navigationTitle("알림")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
