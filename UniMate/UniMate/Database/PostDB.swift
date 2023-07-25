//
//  BoardDB.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/25.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

class PostDB: ObservableObject {
        @Published var posts: [Post] = []
    @Published var changeCount: Int = 0
    
    let ref: DatabaseReference? = Database.database().reference()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func listenToRealtimeDatabase() {
        guard let databasePath = ref?.child("posts") else {
            return
        }
        
        databasePath
            .observe(.childAdded) { [weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let postData = try JSONSerialization.data(withJSONObject: json)
                    let post = try self.decoder.decode(Post.self, from: postData)
                    self.posts.append(post)
                } catch {
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.childChanged){[weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else{
                    return
                }
                do{
                    let postData = try JSONSerialization.data(withJSONObject: json)
                    let post = try self.decoder.decode(Post.self, from: postData)
                    
                    var index = 0
                    for postItem in self.posts {
                        if (post.id == postItem.id){
                            break
                        }else{
                            index += 1
                        }
                    }
                    self.posts[index] = post
                } catch{
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.childRemoved){[weak self] snapshot in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else{
                    return
                }
                do{
                    let postData = try JSONSerialization.data(withJSONObject: json)
                    let post = try self.decoder.decode(Post.self, from: postData)
                    for (index, postItem) in self.posts.enumerated() where post.id == postItem.id {
                        self.posts.remove(at: index)
                    }
                } catch{
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.value){[weak self] snapshot in
                guard
                    let self = self
                else {
                    return
                }
                self.changeCount += 1
            }
    }
    
    func stopListening() {
        ref?.child("posts").removeAllObservers()
    }
    
    func addNewPost(post: Post) {
        self.ref?.child("posts")
            .child("\(post.id)")
            .setValue([
                "id": post.id,
                "title": post.title,
                "content": post.content,
                "authorId": post.authorId,
                "boardId": post.boardId
            ])
    }
    
    func deletePost(key: String) {
        ref?.child("posts/\(key)").removeValue()
    }
    
    func editPost(post: Post) {
        let updates: [String: Any] = [
            "id": post.id,
            "title": post.title,
            "content": post.content,
            "authorId": post.authorId,
            "boardId": post.boardId
        ]
        
        let childUpdates = ["posts/\(post.id)": updates]
        for (index, postItem) in posts.enumerated() where postItem.id == post.id {
            posts[index] = post
        }
        self.ref?.updateChildValues(childUpdates)
    }
}
