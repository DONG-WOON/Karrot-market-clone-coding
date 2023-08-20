//
//  FCMManager.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 8/20/23.
//

import Foundation
import Alamofire

class FCMManager {
    
    private let fcmToken: String
    
    init() {
        self.fcmToken = UserDefaults.standard.string(forKey: UserDefaultsKey.fcmToken) ?? ""
    }
    
    func register() async {
        let response = await AF.request(KarrotRequest.registerFCMToken(self.fcmToken)).serializingDecodable(KarrotResponse<Bool>.self).response
        
        let result = handleResponse(response)
        
        switch result {
        case .success:
            print("FCM 토큰 서버에 등록 성공")
            return
        case .failure(let error):
            print(error)
            return
        }
    }
}
