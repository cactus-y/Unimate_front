//
//  BestPost.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/27.
//

import Foundation

struct BestPost: Identifiable {
    let id = UUID()
    let postID: String
    let originalBoardName: String
    let bestTimestamp: TimeInterval
}
