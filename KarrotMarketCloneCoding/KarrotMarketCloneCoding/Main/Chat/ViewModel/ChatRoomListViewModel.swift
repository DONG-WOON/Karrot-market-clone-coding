//
//  ChatRoomListViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 7/1/23.
//

import Foundation
import Alamofire

class ChatRoomListViewModel {
    
    @Published var chatRoomList: [ChatRoom] = [ChatRoom(chatMateNickname: "co", chatMateEmail: "co@co.com", chatMateProfileUrl: nil, chatMateTownName: nil, lastMessage: "나야", lastChatTime: "", chatroomId: 1)]
  
    func fetchChatRooms() async -> Result<Void, KarrotError> {
        let dataResponse = await AF.request(KarrotRequest.fetchChatRooms).serializingDecodable(KarrotResponse<[ChatRoom]>.self).response
        let result = handleResponse(dataResponse)
        
        switch result {
        case .success(let response):
            
            guard let chatRoomList = response.data else {
                return .failure(.unwrappingError)
            }
            
            self.chatRoomList = chatRoomList
            return .success(())
        case .failure(let error):
            
            return .failure(error)
        }
    }
}
