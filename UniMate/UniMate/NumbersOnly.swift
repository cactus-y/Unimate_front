//
//  NumbersOnly.swift
//  UniMate
//
//  Created by 유석원 on 2023/07/22.
//

import Foundation

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
