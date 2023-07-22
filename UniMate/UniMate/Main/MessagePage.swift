//
//  MessagePage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
            }
            .navigationTitle("쪽지함")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
