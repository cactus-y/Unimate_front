import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    
    var boardName: String
    
    @State private var title: String = ""
    @State private var postContent: String = ""
    @State private var userId: String = ""
    @State private var university: String = ""

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

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
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingImagePicker = true
                    }, label: {
                        Text("이미지 추가하기")
                            .foregroundColor(Color(UIColor(hexCode: "665E5E")))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor(hexCode: "665E5E")), lineWidth: 1)
                            )
                    })
                    Spacer()
                }.padding()

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
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .navigationBarBackButtonHidden(true)
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

        let timestamp = Date().timeIntervalSince1970

        let database = Database.database(url: "https://unimate-16065-default-rtdb.asia-southeast1.firebasedatabase.app/")
        let postRef = database.reference().child(boardName).childByAutoId()

        if let imageData = inputImage?.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference().child("postImages/\(postRef.key!).jpg")

            storageRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                    return
                }

                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        return
                    }
                    guard let url = url else {
                        print("URL is nil")
                        return
                    }

                    let post = Post(author: user.uid, title: title, text: postContent, timestamp: timestamp, postID: postRef.key ?? "", likesCount: 0, university: university, commentCount: 0, imageURL: url.absoluteString)

                    self.savePost(post, at: postRef)
                }
            }
        } else {
            let post = Post(author: user.uid, title: title, text: postContent, timestamp: timestamp, postID: postRef.key ?? "", likesCount: 0, university: university, commentCount: 0, imageURL: "")

            self.savePost(post, at: postRef)
        }
    }

    private func savePost(_ post: Post, at ref: DatabaseReference) {
        let postData = [
            "author": post.author,
            "title": post.title,
            "text": post.text,
            "timestamp": post.timestamp,
            "postID": post.postID,
            "likesCount": post.likesCount,
            "university":post.university,
            "commentCount":post.commentCount,
            "imageURL": post.imageURL
        ] as [String : Any]

        ref.setValue(postData) { (error, _) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                self.dismiss()
            }
        }
    }


    func loadImage() {
        guard let inputImage = inputImage else { return }
        self.inputImage = inputImage
    }
}
