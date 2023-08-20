//
//  SettingViewModel.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import Foundation
import Alamofire

class SettingViewModel {
    
    func logout() async -> Result<Bool, KarrotError> {
        
        let dataResponse = await AF.request(KarrotRequest.logout).serializingDecodable(KarrotResponse<Bool>.self).response
        let result = handleResponse(dataResponse)
        
        switch result {
        case .success:
            HTTPCookieStorage.shared.removeCookies(since: Date(timeIntervalSince1970: 0) )
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}
