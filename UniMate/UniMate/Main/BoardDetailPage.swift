//
//  BoardDetailPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/24.
//

import SwiftUI

struct BoardDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<10) { it in
                    NavigationLink(destination: PostDetailView()) {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                
                                Text("Title1")
                                    .foregroundColor(.black)
                                    .bold()
                                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            HStack {
                                Text("익명")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                
                                Text("07/23")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                
                                Spacer()
                                Label("3", systemImage: "hand.thumbsup")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                Label("5", systemImage: "message")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                            }
                            
                        }
                        .frame(alignment: .leading)
                        .padding(10)
    //                        .onTapGesture {
    //                            print("Move to PostDetailView")
    //                            NavigationLink(destination: PostDetailView(), label: {
    //                                Text("")
    //                            })
    //                        }
                    }
                    
                    Divider()
                }
                
                
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("go back to board page")
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("search a post")
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                
                if title != "BEST 게시판" {
                    ToolbarItem(placement: .navigationBarTrailing) {
    //                    Button {
    //                        print("write a post")
    //                    } label: {
    //                        HStack {
    //                            Image(systemName: "pencil.line")
    //                        }
    //                    }
    //                    NavigationLink(destination: CreatePostView()) {
    //                        Image(systemName: "pencil.line")
    //                    }
                        Button {
                            print("write a post")
                            isPresented.toggle()
                        } label: {
                            Image(systemName: "pencil.line")
                        }
                        .fullScreenCover(isPresented: $isPresented) {
                            CreatePostView()
                        }
                        
                    }
                }
                
                
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView(title: Binding.constant("게시판 이름"))
    }
}
