//
//  ChatRoomListViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 7/1/23.
//

import Foundation
import Alamofire

struct ChatRoomListViewModel {
    
    var chatRoomList: [String] = ["", "", "", "", "", "", "", "", ""]
    
    func fetchChatList() async {
//        let data = await AF.request(KarrotRequest.fetchChatroomList).serializingData().response.data
//        print(data?.toDictionary())
//        AF.request(KarrotRequest.fetchChatroomList).serializingDecodable(KarrotResponse<>.self).response
    }
}
