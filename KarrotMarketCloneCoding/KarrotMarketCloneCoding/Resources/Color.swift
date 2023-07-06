//
//  Color.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/12.
//

import Foundation
import UIKit

enum AssetColor {
    case carrot
}

extension UIColor {
    
    static func appColor(_ name: AssetColor) -> UIColor {
        switch name {
        case .carrot:
            return UIColor(red: 237/255, green: 119/255, blue: 50/255, alpha: 1)
        }
    }
}
