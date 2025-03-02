//
//  Formatters.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/28.
//

import Foundation

extension DateFormatter {
    
    static let myDateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return dateFormatter
    }()
}

extension NumberFormatter {
    
    static let Decimal: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}
