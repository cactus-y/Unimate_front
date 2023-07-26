import SwiftUI
import FirebaseDatabase


struct FreeBoardDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    @State private var posts: [FreeBoardPost] = []
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(posts) { post in
                    NavigationLink(destination: FreeBoardPostDetailView()) {
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
                                Text("익명")
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
                            FreeBoardCreatePostView()
                        }
                    }
                }
            }
            .onAppear(perform: loadPosts)
        }
        .navigationBarBackButtonHidden()
    }

    private func loadPosts() {
        let ref = Database.database().reference().child("freeBoard")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let dict = child.value as? [String: Any],
                   let author = dict["author"] as? String,
                   let title = dict["title"] as? String,
                   let text = dict["text"] as? String,
                   let timestamp = dict["timestamp"] as? TimeInterval,
                   let postID = dict["postID"] as? String,
                   let likesCount = dict["likesCount"] as? Int,
                   let university = dict["university"] as? String,
                   let commentCount = dict["commentCount"] as? Int {
                    let post = FreeBoardPost(id: UUID(), author: author, title: title, text: text, timestamp: timestamp, postID: postID, likesCount: likesCount, university: university, commentCount: commentCount)
                    self.posts.append(post)
                }
            }
            self.posts.sort { $0.timestamp > $1.timestamp }
        }
    }


}

struct FreeBoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView(title: Binding.constant("게시판 이름"))
    }
}
