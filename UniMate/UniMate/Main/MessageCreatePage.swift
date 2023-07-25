//
//  MessageCreatePage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/25.
//

import SwiftUI

struct MessageCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var postContent: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .topLeading) {
                    
                    TextEditor(text: $postContent)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                        .padding(.leading, 10)
                        .lineLimit(1)
                    
                    if postContent.isEmpty {
                        Text("내용")
                            .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            .padding(.top, 13)
                            .disabled(true)
                            .padding(.leading, 15)
                    }
    
                    
                }
                
                Spacer()
            }
            .navigationTitle("새 쪽지 보내기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // later change this
                        // go back to message view
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct MessageCreateView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCreateView()
    }
}
