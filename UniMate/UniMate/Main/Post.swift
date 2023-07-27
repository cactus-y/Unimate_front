//
//  Post.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/27.
//

import Foundation

struct Post: Identifiable {
    let id = UUID()
    let author: String
    let title :String
    let text: String
    let timestamp: TimeInterval
    let postID: String
    let likesCount: Int
    let university: String
    let commentCount: Int
}
