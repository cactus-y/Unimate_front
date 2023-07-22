//
//  UnivVerificationPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI

struct UnivVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    print("go back to user info sign up page")
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
//                        Text("Back")
                    }
                }
            }
        }
    }
}
