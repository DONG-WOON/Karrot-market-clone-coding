//
//  Chat.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import Foundation


struct ChatMessage: Codable {
    let id: Int
    let email: String // 또는 id
    let message: String
    let date: Date
    // image
}

extension ChatMessage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
