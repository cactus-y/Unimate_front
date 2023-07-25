//
//  Post.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/25.
//

import Foundation

struct Post: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var content: String
    // foreign keys
    var authorId: String
    var boardId: String
}
