//
//  CreatePostPage.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    
    var boardName: String
    
    @State private var title: String = ""
    @State private var postContent: String = ""
    @State private var userId: String = ""
    @State private var university: String = ""
    
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
                        self.uploadPost()
                    }, label: {
                        Text("완료")
                            .foregroundColor(.black)
                    })
                    .disabled(title == "" || postContent == "")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear(perform: loadUserData)
    }
    
    func loadUserData() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            
            let db = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(self.userId)

            db.child("university").observeSingleEvent(of: .value) { snapshot in
                self.university = snapshot.value as? String ?? ""
            }
        }
    }
    
    private func uploadPost() {
        guard let user = Auth.auth().currentUser else {
            print("No user logged in.")
            return
        }

        // We will generate the timestamp inside this function
        let timestamp = Date().timeIntervalSince1970

        // We generate a new post ID by creating a new child in the "freeBoard" node
        let database = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app/")
        let postRef = database.reference().child(boardName).childByAutoId()

        let post = Post(author: user.uid, title: title, text: postContent, timestamp: timestamp, postID: postRef.key ?? "", likesCount: 0, university: university,commentCount: 0)

        // Convert our post to a dictionary because this is the data type that Firebase expects
        let postData = [
            "author": post.author,
            "title": post.title,
            "text": post.text,
            "timestamp": post.timestamp,
            "postID": post.postID,
            "likesCount": post.likesCount,
            "university":post.university,
            "commentCount":post.commentCount,
        ] as [String : Any]

        // Save our post data to the new post ID
        postRef.setValue(postData) { (error, _) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                self.dismiss()
            }
        }
    }
}

//struct CreatePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatePostView()
//    }
//}
