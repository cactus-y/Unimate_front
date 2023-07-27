//
//  BoardDetailPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/24.
//

import SwiftUI
import FirebaseDatabase

struct BoardDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    @State private var posts: [Post] = []
    @State var dbBoardName: String = ""
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if posts.isEmpty {
                    Text("아직 글이 없어요!")
                } else {
                    ForEach(posts) { post in
                        // pass post info to PostDetailView()
                        NavigationLink(destination: PostDetailView(post: post, boardName: dbBoardName)) {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    
                                    Text(post.title)
                                        .foregroundColor(.black)
                                        .bold()
                                    Text(post.text)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                HStack {
                                    Text(post.university)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                    
                                    Text(Date(timeIntervalSince1970: post.timestamp), style: .date)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                    
                                    Spacer()
                                    Label("\(post.likesCount)", systemImage: "hand.thumbsup")
                                        .font(.system(size: 12))
                                        .foregroundColor(.red)
                                    Label("\(post.commentCount)", systemImage: "message")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                }
                                
                            }
                            .frame(alignment: .leading)
                            .padding(10)
                        }
                        
                        Divider()
                    }
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
                        Button {
                            print("write a post")
                            isPresented.toggle()
                        } label: {
                            Image(systemName: "pencil.line")
                        }
                        .fullScreenCover(isPresented: $isPresented) {
                            // pass title to CreatePostView()
                            CreatePostView(boardName: dbBoardName)
                                .onDisappear(perform: loadPosts)
                                
                        }
                        
                    }
                }
                
                
            }
            .onAppear(perform: loadPosts)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func loadPosts() {
        let database = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app/")
        var ref: DatabaseReference?
        
        if(title == "자유 게시판") {
            dbBoardName = "freeBoard"
        } else if(title == "대학원 게시판") {
            dbBoardName = "gradBoard"
        } else if(title == "동아리 게시판") {
            dbBoardName = "clubBoard"
        } else if(title == "홍보 게시판") {
            dbBoardName = "adBoard"
        } else if(title == "길냥이 게시판") {
            dbBoardName = "catBoard"
        } else if(title == "BEST 게시판") {
            dbBoardName = "bestBoard"
        }
        
        ref = database.reference().child(dbBoardName)
        
        if(ref != nil) {
            ref!.observeSingleEvent(of: .value) { (snapshot, string) in
                self.posts = []
                
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    if let dict = child.value as? [String: Any],
                       let author = dict["author"] as? String,
                       let title = dict["title"] as? String,
                       let text = dict["text"] as? String,
                       let timestamp = dict["timestamp"] as? TimeInterval,
                       let postID = dict["postID"] as? String,
                       let likesCount = dict["likesCount"] as? Int,
                       let university = dict["university"] as? String,
                       let commentCount = dict["commentCount"] as? Int,
                       let imageURL = dict["imageURL"] as? String {  // Add this line for imageURL
                        let post = Post(author: author, title: title, text: text, timestamp: timestamp, postID: postID, likesCount: likesCount, university: university, commentCount: commentCount, imageURL: imageURL) // Update this line with imageURL
                        self.posts.append(post)
                    }

                }
                self.posts.sort{ $0.timestamp > $1.timestamp }
            }
        }
    }
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView(title: Binding.constant("게시판 이름"))
    }
}
