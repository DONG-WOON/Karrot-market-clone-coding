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
    let chatMateTownName: String
    let lastMessage: String
    let lastChatTime: String
    let chatroomId: Int
}

struct ChatMessage: Codable, Hashable {
    let email: String // 또는 id
    let senderNickName: String
    let senderProfileUrl: String?
    let receiverNickname: String
    let receiverProfileUrl: String?
    let createDateTime: Date
    let message: String?
}
