//
//  PostDetailPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct PostDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var post: Post
    var boardName: String
    
    @State private var newComment: String = ""
    @State private var comments: [Comment] = []
    @State private var userId: String = ""
    @State private var university: String = ""
    @State private var like: Bool = false
    @State var likeCount: Int = 0
    @State var commentCount: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading) {
                        // title and author
                        
                        HStack {
                            Image(systemName: "person")
                            VStack(alignment: .leading) {
                                Text(post.university)
                                    .bold()
                                Text(formatDate(timestamp: post.timestamp))
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            }
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        Divider()
                        
                        Text(post.title)
                            .font(.title3)
                            .bold()
                            .padding(.bottom, 10)
                        
                        
                        
                        
                        // post content
                        Text(post.text)
                        
                        // like/unlike
                        HStack {
                            Label(String(post.likesCount), systemImage: like ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .onTapGesture {
                                    toggleLikeStatus()
                                }
                            Label(String(post.commentCount), systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    

                        Divider()
                        // comments list
                        ForEach(comments) { comment in
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "person")
                                    Text(comment.university)
                                        .bold()
                                    Spacer()
                                    Text(formatDate(timestamp: comment.timestamp))
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                                }
            
                                Text(comment.text)
                                
                                Divider()
                            }
                        }
                        
                        
                    }
                    .padding(15)
                }
                HStack {
                    TextField("Comment",
                              text: $newComment,
                              prompt: Text("댓글 쓰기").foregroundColor(Color(UIColor(hexCode: "665E5E")))
                    )
                    .padding(15)
                    .background(Color(UIColor(hexCode: "DCD7D7")))
                    .cornerRadius(15)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    
                    
                    Button {
                        print("Write a comment")
                        
                        let c = Comment(author: self.userId, text: newComment, timestamp: Date().timeIntervalSince1970, postID: post.postID, university: university)
                        
                        comments.append(c)
                        
                        // add to db
                        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("comments").childByAutoId()
                        
                        db.setValue([
                            "author": c.author,
                            "text": c.text,
                            "timestamp": c.timestamp,
                            "postID": c.postID,
                            "university": c.university
                        ])
                        
                        // fetch current commentCount of the post
                        let postDB = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child(boardName).child(c.postID)
                        
                        postDB.observeSingleEvent(of: .value) { snapshot in
                            if let postData = snapshot.value as? [String: Any] {
                                var commentCount = postData["commentCount"] as? Int ?? 0
                                commentCount += 1
                                
                                // update commentCount of the post
                                postDB.updateChildValues(["commentCount": commentCount])
                            }
                        }
                        
                        newComment = ""
                    } label: {
                        Image(systemName: "pencil.line")
                            .padding(17)
                            .background(Color(UIColor(hexCode: "70BBF9")))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    .disabled(newComment.isEmpty)
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
        .onAppear(perform: {
            loadUserData()
            loadComments()
            loadLikeStatus()
            loadLikeCount()
        })
    }
    
    func loadLikeStatus() {
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        // Check if the user liked the post
        db.child("likes").child(userId).child(post.postID).observeSingleEvent(of: .value) { snapshot in
            self.like = snapshot.value as? Bool ?? false
        }
    }
    
    
    func loadLikeCount() {
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

        // Fetch the likesCount of the post
        db.child(boardName).child(post.postID).observeSingleEvent(of: .value) { snapshot in
            if let postData = snapshot.value as? [String: Any] {
                self.likeCount = postData["likesCount"] as? Int ?? 0
            }
        }
    }

    
    func toggleLikeStatus() {
        like = !like
        
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        // update user's like status
        db.child("likes").child(userId).child(post.postID).setValue(like)
        
        // update post's like status
        db.child(boardName).child(post.postID).observeSingleEvent(of: .value) { snapshot in
            if var postData = snapshot.value as? [String: Any] {
                var likesCount = postData["likesCount"] as? Int ?? 0
                likesCount = like ? likesCount + 1 : likesCount - 1
                postData["likesCount"] = likesCount
                self.likeCount = likesCount
                snapshot.ref.setValue(postData)
            }
        }
    }
    
    func loadUserData() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            
            let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
            
            let dbUser = db.child("users").child(self.userId)
            
            dbUser.child("university").observeSingleEvent(of: .value) { snapshot in
                self.university = snapshot.value as? String ?? ""
            }
        }
    }
    
    func loadComments() {
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        let commentDB = db.child("comments")
        
        commentDB.observe(.value) { snapshot in
            var loadedComments = [Comment]()
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let commentData = snapshot.value as? [String: Any],
                   let author = commentData["author"] as? String,
                   let text = commentData["text"] as? String,
                   let timestamp = commentData["timestamp"] as? TimeInterval,
                   let postID = commentData["postID"] as? String,
                   let university = commentData["university"] as? String,
                   postID == self.post.postID
                {
                    let comment = Comment(author: author, text: text, timestamp: timestamp, postID: postID, university: university)
                    loadedComments.append(comment)
                }
            }
            self.comments = loadedComments.sorted(by: { $0.timestamp < $1.timestamp })
        }
    }
    
    func formatDate(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

//struct PostDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetailView()
//    }
//}
