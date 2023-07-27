//
//  BoardPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import SwiftUI
import FirebaseDatabase

struct BoardView: View {
    
    @State private var bestPosts: [BestPost] = []
    @State private var posts: [Post] = []
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading){

                    NavigationLink(destination: BoardDetailView(title: Binding.constant("BEST 게시판"))) {
                        HStack {
                            Text("BEST 게시판")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
    //                    .onTapGesture {
    //                        // give on tap gesture to entire hstack?
    //                        print("Go to BEST board?")
    //                    }
                    }
                    
                    
                    Divider()
                        .background(Color.black)
                    
//                    NavigationLink(destination: PostDetailView()) {
//                        VStack(alignment: .leading) {
//                            VStack(alignment: .leading) {
//                                HStack {
//                                    Image(systemName: "person")
//                                        .foregroundColor(.black)
//                                    Text("익명")
//                                        .foregroundColor(.black)
//                                        .bold()
//                                    Spacer()
//                                    Text("07/23")
//                                        .font(.system(size: 12))
//                                        .foregroundColor(Color(UIColor(hexCode: "665E5E")))
//                                }
//                                Text("Title1")
//                                    .foregroundColor(.black)
//                                    .bold()
//                                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
//                                    .foregroundColor(.black)
//                                    .lineLimit(2)
//                            }
//
//                            HStack {
//                                Text("자유게시판")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
//                                Spacer()
//                                Label("3", systemImage: "hand.thumbsup")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.red)
//                                Label("5", systemImage: "message")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.blue)
//                            }
//
//                        }
//                        .frame(alignment: .leading)
//                        .padding(10)
////                        .onTapGesture {
////                            print("Move to PostDetailView")
////                            NavigationLink(destination: PostDetailView(), label: {
////                                Text("")
////                            })
////                        }
//                    }
                    
                    
                            
         
            
                    
                    
                }
                .padding(10)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor(hexCode: "969696")), lineWidth: 1)
                )
                .padding(.horizontal)
                
                VStack (alignment: .leading){
                    HStack {
                        Text("게시판 목록")
                    }

                    
                    Divider()
                        .background(Color.black)
                    
                    NavigationLink(destination: BoardDetailView(title: Binding.constant("자유 게시판"))) {
                        HStack {
                            Text("자유 게시판")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical)
    //                    .onTapGesture {
    //                        // give on tap gesture to entire hstack?
    //                        print("Go to community board?")
    //                    }
                    }
                    
                    NavigationLink(destination: BoardDetailView(title: Binding.constant("대학원 게시판"))) {
                        HStack {
                            Text("대학원 게시판")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical)
    //                    .onTapGesture {
    //                        // give on tap gesture to entire hstack?
    //                        print("Go to community board?")
    //                    }
                    }
                    
                    NavigationLink(destination: BoardDetailView(title: Binding.constant("동아리 게시판"))) {
                        HStack {
                            Text("동아리 게시판")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical)
    //                    .onTapGesture {
    //                        // give on tap gesture to entire hstack?
    //                        print("Go to community board?")
    //                    }
                    }
                    
                    NavigationLink(destination: BoardDetailView(title: Binding.constant("홍보 게시판"))) {
                        HStack {
                            Text("홍보 게시판")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical)
    //                    .onTapGesture {
    //                        // give on tap gesture to entire hstack?
    //                        print("Go to community board?")
    //                    }
                    }
                    
                    NavigationLink(destination: BoardDetailView(title: Binding.constant("길냥이 게시판"))) {
                        HStack {
                            Text("길냥이 게시판")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical)
    //                    .onTapGesture {
    //                        // give on tap gesture to entire hstack?
    //                        print("Go to community board?")
    //                    }
                    }
                    
                    
                    
                }
                .padding(10)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor(hexCode: "969696")), lineWidth: 1)
                )
                .padding(.vertical)
                .padding(.horizontal)
            }
            .onAppear(perform: loadBestPosts)
            .navigationTitle("게시판")
            .navigationBarTitleDisplayMode(.inline)
            
            
            
            

        }
    }
    
    private func loadBestPosts() {
        let bestDB = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app/").reference().child("bestBoard")
        
        bestDB.observeSingleEvent(of: .value) { (snapshot, string) in
            self.bestPosts = []
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let dict = child.value as? [String: Any],
                   let postID = dict["postID"] as? String,
                   let originalBoardName = dict["originalBoardName"] as? String,
                   let bestTimestamp = dict["bestTimestamp"] as? TimeInterval {
                    let bestPost = BestPost(postID: postID, originalBoardName: originalBoardName, bestTimestamp: bestTimestamp)
                    self.bestPosts.append(bestPost)
                }
            }
            
            self.bestPosts.sort { $0.bestTimestamp > $1.bestTimestamp }
        }
        
//        for bestpost in self.bestPosts {
//            let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
//
//            db.child(bestpost.originalBoardName).child(bestpost.postID).observeSingleEvent(of: .value) { snapshot in
//                if var postData = snapshot.value as? [String: Any] {
//                    let author = postData["author"] as? String
//                    let title = postData["title"] as? String
//                    let commentCount = postData["commentCount"] as? Int
//                    let likesCount = postData["likesCount"] as? Int
//                    let postID = postData["postID"] as? String
//                    let text = postData["text"] as? String
//                    let timestamp = postData["timestamp"] as? TimeInterval
//                    let university = postData["university"] as? String
//
//                    let post = Post(author: author, title: title, text: text, timestamp: timestamp, postID: postID, likesCount: likesCount, university: university, commentCount: commentCount)
//
//                    self.posts.append(post)
//                }
//            }
//        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
