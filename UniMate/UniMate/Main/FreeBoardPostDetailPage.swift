import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let text: String
    let timestamp: TimeInterval
    let postID: String
    let university: String
}


struct FreeBoardPostDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var comment: String = ""
    @State var like: Bool = false
    @State var likeCount: Int
    @State var comments: [Comment] = []
    @State private var university: String = ""
    @State private var userID: String = ""
    @State var commentCount: Int
    
    var post: FreeBoardPost
    
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
                        
                        Text(post.title)
                            .bold()
                        
                        Divider()
                        
                        // post content
                        Text(post.text)
                        
                        // like/unlike
                        HStack {
                            Label(String(likeCount), systemImage: like ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .onTapGesture {
                                    toggleLikeStatus()
                                }
                            Label(String(post.commentCount), systemImage: "message")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                        
                        Divider()

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
                            }
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

                        let newComment = Comment(author: self.userID, text: comment, timestamp: Date().timeIntervalSince1970, postID: post.postID, university: university)
                        comments.append(newComment)

                        // Add the comment to the database
                        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("comments").childByAutoId()

                        db.setValue([
                            "author": newComment.author,
                            "text": newComment.text,
                            "timestamp": newComment.timestamp,
                            "postID": newComment.postID,
                            "university": newComment.university
                        ])

                        // Fetch the current commentCount of the post
                        let postDB = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("freeBoard").child(newComment.postID)
                        
                        postDB.observeSingleEvent(of: .value) { snapshot in
                            if let postData = snapshot.value as? [String: Any] {
                                var commentCount = postData["commentCount"] as? Int ?? 0
                                commentCount += 1
                                
                                // Update the commentCount of the post
                                postDB.updateChildValues(["commentCount": commentCount])
                            }
                        }

                        comment = ""
                    }

 label: {
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
        .onAppear(perform:{
            loadUserData()
            loadComments()
            loadLikeStatus()
            loadLikeCount()
        }
        )
    }
    func loadLikeStatus() {
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

        // Check if the user liked the post
        db.child("likes").child(userID).child(post.postID).observeSingleEvent(of: .value) { snapshot in
            self.like = snapshot.value as? Bool ?? false
        }
    }
    
    
    func loadLikeCount() {
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

        // Fetch the likesCount of the post
        db.child("freeBoard").child(post.postID).observeSingleEvent(of: .value) { snapshot in
            if let postData = snapshot.value as? [String: Any] {
                self.likeCount = postData["likesCount"] as? Int ?? 0
            }
        }
    }



    func toggleLikeStatus() {
        like = !like
        
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        // Update the user's like status
        db.child("likes").child(userID).child(post.postID).setValue(like)
        
        // Update the post's like count
        db.child("freeBoard").child(post.postID).observeSingleEvent(of: .value) { snapshot in
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
            self.userID = user.uid
            
            let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(self.userID)

            db.child("university").observeSingleEvent(of: .value) { snapshot in
                self.university = snapshot.value as? String ?? ""
            }
        }
    }
    func loadComments() {
        let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("comments")
        
        db.observe(.value) { snapshot in
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

struct FreeBoardPostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FreeBoardPostDetailView(likeCount: 4, commentCount: 3, post: FreeBoardPost(author: "author", title: "Test", text: "Test Content", timestamp: Date().timeIntervalSince1970, postID: "postID",  likesCount: 5,university: "고려대학교", commentCount: 3))
    }
}


