//
//  BoardPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct BoardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
            }
            .navigationTitle("게시판")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
