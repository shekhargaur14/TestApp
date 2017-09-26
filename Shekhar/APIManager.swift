//
//  APIManager.swift
//  Shekhar
//
//  Created by Ved Kshirsagar on 25/09/17.
//  Copyright © 2017 Ved Kshirsagar. All rights reserved.
//

import Foundation

class APIManager {
    
    static let sharedInstance = APIManager()
    
    //Get all location data
    func getLocationData(success : @escaping (NSArray) -> Void , failure : (NSError) -> Void) {
        let url : URL! = URL(string: BASE_URL)
        let request : URLRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as! NSArray
                    let model = LocationModel()
                    let data = model.parseLocationData(data: jsonData)
                    success(data)
                }catch{
                    print("asdasd")
                }

            }
        }
    task.resume()
        
    }
}
