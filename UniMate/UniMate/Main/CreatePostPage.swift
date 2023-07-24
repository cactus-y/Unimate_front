//
//  CreatePostPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/24.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var title: String = ""
    @State var postContent: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("제목",
                          text: $title,
                          prompt: Text("제목").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                )
                .frame(alignment: .leading)
                .padding(.top, 10)
                .background(.white)
                .padding(.horizontal)
                Divider()
//                TextField("내용",
//                          text: $postContent,
//                          axis: .vertical
//
//                )
//                .padding(15)
//                .background(.white)
//                .padding(.horizontal)
                
                
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
            .navigationTitle("새 글 쓰기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("go back to board detail view")
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark").foregroundColor(.black)
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // later change the action
                        print("go back to board detail view")
                        dismiss()
                    }, label: {
                        Text("완료")
                            .foregroundColor(.black)
                    })
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
