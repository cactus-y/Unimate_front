//
//  PostDetailPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/24.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var comment: String = ""
    @State var like: Bool = false
    @State var likeCount: Int = 3
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading) {
                        // title and author
                        Text("Title1")
                            .bold()

                        
                        
                        HStack {
                            Image(systemName: "person")
                            VStack(alignment: .leading) {
                                Text("고려대학교1")
                                    .bold()
                                Text("07/23 12:00")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            }
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        
                        Divider()
                        
                        // post content
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam bibendum purus sit amet pretium placerat. Aenean placerat erat non enim varius efficitur. Mauris quis vehicula urna, sit amet congue nisi. Aliquam maximus magna quis volutpat commodo. Vivamus elit erat, bibendum nec ante a, feugiat lobortis erat. Vestibulum id arcu at leo laoreet vestibulum nec vel ligula. Donec hendrerit, odio et ornare consequat, tellus felis placerat augue, ac egestas velit odio eget felis. Quisque nisi orci, blandit ac condimentum auctor, malesuada sit amet diam. Donec congue, lacus vel elementum ornare, orci ligula pellentesque leo, id molestie tortor augue vitae diam. Mauris orci magna, mattis eget ullamcorper nec, bibendum egestas dolor. Nullam et ipsum fermentum, pharetra ante non, placerat elit. Nulla consequat purus sit amet metus sollicitudin, rhoncus tempus ex pellentesque.")
                        
                        // like/unlike
                        HStack {
                            Label(String(likeCount), systemImage: like ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .onTapGesture {
                                    if like {
                                        like = false
                                        likeCount -= 1
                                    } else {
                                        like = true
                                        likeCount += 1
                                    }
                                }
                            Label("5", systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                        
//                        HStack {
//                            Spacer()
//
//                            Button {
//                                print("Like")
//                            } label: {
//                                Image(systemName: "hand.thumbsup.circle")
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//
//                                    .foregroundColor(Color(UIColor(hexCode: "70BBF9")))
//                                    .cornerRadius(15)
//                            }
//
//                            Spacer()
//                        }
        
                        
                        
                        
                        Divider()
                        // comments list
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person")
                                Text("한양대학교1")
                                    .bold()
                                Spacer()
                                Text("07/23 12:01")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            }
        
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                                
                        }
                        
                    }
                    .padding(15)
                }
                HStack {
                    TextField("Comment",
                              text: $comment,
                              prompt: Text("댓글 쓰기").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                    )
                    .padding(15)
                    .background(Color(UIColor(hexCode: "DCD7D7")))
                    .cornerRadius(15)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    
                    
                    Button {
                        print("Write a comment")
                    } label: {
                        Image(systemName: "pencil.line")
                            .padding(17)
                            .background(Color(UIColor(hexCode: "70BBF9")))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    .disabled(comment.isEmpty)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            .navigationTitle("자유게시판")
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
                        print("menu")
                    } label: {
                        HStack {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
    }
}
