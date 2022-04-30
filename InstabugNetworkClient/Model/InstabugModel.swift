//
//  InstabugModel.swift
//  InstabugNetworkClient
//
//  Created by Esraa Gamal on 30/04/2022.
//

import Foundation

enum Size {
    
    case KB
    case MB
    
    var length : Int {
        switch self {
        case .KB:
            return 1024
        case .MB:
            return 1024 * Size.KB.length
        }
    }
}
