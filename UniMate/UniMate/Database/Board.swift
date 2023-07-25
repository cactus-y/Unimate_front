//
//  Board.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/25.
//

import Foundation

struct Board: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var isBest: Bool
}
