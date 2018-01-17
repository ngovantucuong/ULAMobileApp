//
//  Country.swift
//  ULAMobileApp
//
//  Created by ngovantucuong on 1/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

class Country: NSObject {
    var name: String
    var dial_code: String
    var code: String
    var flagCountry: String?
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as! String
        dial_code = dictionary["dial_code"] as! String
        code = dictionary["code"] as! String
    }
}
