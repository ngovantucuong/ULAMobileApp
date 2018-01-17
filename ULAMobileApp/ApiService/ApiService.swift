//
//  ApiService.swift
//  ULAMobileApp
//
//  Created by ngovantucuong on 1/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    static let shareInstance = ApiService()
    
    func fetchDataJsonFrom(url: String, complete: @escaping([Country]) -> ()) {
        var jsonData = [String: Any]()
        let Url = NSURL(string: url)
        var countryArray = [Country]()
        
        URLSession.shared.dataTask(with: Url! as URL, completionHandler: {(data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if let data = data {
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let countryDictionary = jsonData["Country"] as! [[String: Any]]
                    for countryItem in countryDictionary {
                        let country = Country(dictionary: countryItem)
                        country.flagCountry = self.flag(country: countryItem["code"] as! String)
                        countryArray.append(country)
                    }
                    complete(countryArray)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }).resume()
    }
    
    func flag(country: String) -> String {
        let base: UInt32 = 127397
        return country.unicodeScalars.flatMap { String.init(UnicodeScalar(base + $0.value)!) }.joined()
    }
}
