import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let text: String
    let timestamp: TimeInterval
}


struct FreeBoardPostDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var comment: String = ""
    @State var like: Bool = false
    @State var likeCount: Int
    @State var comments: [Comment] = []
    @State private var university: String = ""
    @State private var userID: String = ""
    
    var post: FreeBoardPost
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading) {
                        // title and author
                        Text(post.title)
                            .bold()

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
                        
                        // post content
                        Text(post.text)
                        
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
                                    Text(comment.author)
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

                        let newComment = Comment(author: university, text: comment, timestamp: Date().timeIntervalSince1970)
                        comments.append(newComment)
                        comment = ""

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
        .onAppear(perform: loadUserData)
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
    func formatDate(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

struct FreeBoardPostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FreeBoardPostDetailView(likeCount: 0,post: FreeBoardPost(author: "author", title: "Test", text: "Test Content", timestamp: Date().timeIntervalSince1970, postID: "postID", likesCount: 5, university: "고려대학교", commentCount: 3))


    }
}

