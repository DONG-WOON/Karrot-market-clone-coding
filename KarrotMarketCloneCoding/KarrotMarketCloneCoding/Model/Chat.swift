//
//  Chat.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/10/14.
//

import Foundation

struct ChatRoom: Codable {
    let chatMateNickname: String
    let chatMateEmail: String
    let chatMateProfileUrl: String?
    let chatMateTownName: String?
    let lastMessage: String?
    let lastChatTime: String?
    let chatroomId: Int?
}

// MARK: - Chat Log
struct ChatLog: Codable {
    let content: [Message]
    let pageable: Pageable
    let first, last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let empty: Bool
}

struct Message: Codable, Hashable {
    // ⭐️ TO DO: 원래는 메일이나 id같은 고유값을 갖고 있어야함. ⭐️
    let senderNickname: String
    let senderProfileURL: String?
    let receiverNickname: String
    let receiverProfileURL: String?
    let createDateTime: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case senderNickname = "senderNickName"
        case senderProfileURL = "senderProfileUrl"
        case receiverNickname
        case receiverProfileURL = "receiverProfileUrl"
        case createDateTime
        case message
    }
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
