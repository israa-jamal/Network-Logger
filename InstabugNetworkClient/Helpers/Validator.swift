//
//  Validator.swift
//  InstabugNetworkClient
//
//  Created by Esraa Gamal on 30/04/2022.
//

import Foundation

class Validator {
    
    class func validateLengthOf(text: String, withMaximum size: Size) -> Bool {
        return text.count <= size.length
    }
    
}
