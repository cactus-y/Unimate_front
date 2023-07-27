//
//  Comment.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/27.
//

import Foundation

struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let text: String
    let timestamp: TimeInterval
    let postID: String
    let university: String
}
