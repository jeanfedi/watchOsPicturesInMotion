//
//  FlickrImage.swift
//  picturesInMotion
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//

import Foundation
class FlickrImage {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String?
    
    var imageUrl: String {
        get {
            return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        }
    }
    
    var thumbnailUrl: String {
        get {
            return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
        }
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.owner = dictionary["owner"] as! String
        self.secret = dictionary["secret"] as! String
        self.server = dictionary["server"] as! String
        self.farm = dictionary["farm"] as! Int
        self.title = dictionary["title"] as! String?
    }
}
