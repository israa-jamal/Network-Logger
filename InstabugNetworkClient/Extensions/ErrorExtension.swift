//
//  ErrorExtension.swift
//  InstabugNetworkClient
//
//  Created by Esraa Gamal on 30/04/2022.
//

import Foundation

extension Error {
    var errorCode: Int64? {
        return Int64((self as NSError).code)
    }
    
    var errorDomain: String {
        return (self as NSError).domain
    }
}
