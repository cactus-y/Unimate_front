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

class BoardDB: ObservableObject {
    @Published var boards: [Board] = []
    @Published var changeCount: Int = 0
    
    let ref: DatabaseReference? = Database.database().reference()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func listenToRealtimeDatabase() {
        guard let databasePath = ref?.child("boards") else {
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
                    let boardData = try JSONSerialization.data(withJSONObject: json)
                    let board = try self.decoder.decode(Board.self, from: boardData)
                    self.boards.append(board)
                } catch {
                    print("an error occurred", error)
                }
                
            }
        
        databasePath
            .observe(.childChanged) { [weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let boardData = try JSONSerialization.data(withJSONObject: json)
                    let board = try self.decoder.decode(Board.self, from: boardData)
                    
                    var index = 0
                    for boardItem in self.boards {
                        if board.id == boardItem.id {
                            break
                        } else {
                            index += 1
                        }
                    }
                    self.boards[index] = board
                } catch {
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.childRemoved) { [weak self] snapshot in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let boardData = try JSONSerialization.data(withJSONObject: json)
                    let board = try self.decoder.decode(Board.self, from: boardData)
                    for (index, boardItem) in self.boards.enumerated() where board.id == boardItem.id {
                        self.boards.remove(at: index)
                    }
                } catch {
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.value) { [weak self] snapshot in
                guard
                    let self = self
                else {
                    return
                }
                self.changeCount += 1
            }
    }
    
    func stopListening() {
        ref?.child("boards").removeAllObservers()
    }
}
