//
//  ChatViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 7/6/23.
//

import Foundation
import Alamofire

class ChatViewModel {
    
    let chatroom: ChatRoom
    let myEmail: String
    let myNickname: String
    let webSocketManager: WebSocketManager
    var chats: [Message] = []
    
    init(chatRoom: ChatRoom) {
        self.chatroom = chatRoom
        self.myEmail = UserDefaults.standard.string(forKey: UserDefaultsKey.myEmail) ?? ""
        self.myNickname = UserDefaults.standard.string(forKey: UserDefaultsKey.myNickname) ?? ""
        
        webSocketManager = WebSocketManager()
        webSocketManager.connect()
        webSocketManager.subscribe(opponentEmail: chatroom.chatMateEmail, myEmail: myEmail)
    }
    
    func fetchChatLog(completion: () -> Void) async {
        guard let roomID = chatroom.chatroomId else { return }
        let response = await AF.request(KarrotRequest.fetchChatLog(roomID)).serializingDecodable(KarrotResponse<ChatLog>.self).response
        let result = handleResponse(response)
        switch result {
        case .success(let karrotResponse):
            guard let log = karrotResponse.data else { return }
            self.chats = log.content
            completion()
        case .failure(let error):
            print(error)
        }
    }
    
    func sendMessage(text: String, completion: @escaping (Message) -> Void) {
        webSocketManager.sendMessage(text, opponentEmail: chatroom.chatMateEmail, myEmail: myEmail)
        let message = Message(senderNickname: myNickname, senderProfileURL: nil, receiverNickname: chatroom.chatMateNickname, receiverProfileURL: chatroom.chatMateProfileUrl, createDateTime: Date.now.formatToString(), message: text)
        completion(message)
    }
    
    func receiveMessage(message: Message) {
        chats.append(message)
    }
    
    deinit {
        webSocketManager.disconnect()
    }
}

