//
//  LocationModel.swift
//  Shekhar
//
//  Created by Ved Kshirsagar on 25/09/17.
//  Copyright © 2017 Ved Kshirsagar. All rights reserved.
//

import Foundation

class LocationModel {
    
    //MARK: Properties
    var albumId : Int?
    var id : Int?
    var title : String?
    var url : String?
    var thumbnailUrl : String?
    
//    //MARK: Initialization
//    init() {
//        albumId = Int()
//        id = Int()
//        title = String()
//        url = String()
//        thumbnailUrl = String()
//    }
//    
//    init(albumID: Int, id : Int, title : String, url : String, thumbnailUrl : String) {
//        self.albumId = albumID
//        self.id = id
//        self.title = title
//        self.url = url
//        self.thumbnailUrl = thumbnailUrl
//    }
    
    //MARK: Parsing
    func parseLocationData(data:NSArray) -> NSArray {
        let responseArray : NSMutableArray = NSMutableArray()
        for item in data {
            let dataDictionay = item as! NSDictionary
            let locationObject = LocationModel()
            locationObject.albumId = dataDictionay.value(forKey: "albumId") as? Int
            locationObject.id = dataDictionay.value(forKey: "id") as? Int
            locationObject.title = dataDictionay.value(forKey: "title") as? String
            locationObject.url = dataDictionay.value(forKey: "url") as? String
            locationObject.thumbnailUrl = dataDictionay.value(forKey: "thumbnailUrl") as? String
            responseArray.add(locationObject)
        }
        let resultData = responseArray as NSArray
        return resultData
    }
}
