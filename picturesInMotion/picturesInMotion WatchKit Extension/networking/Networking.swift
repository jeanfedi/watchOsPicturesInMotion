//
//  Networking.swift
//  picturesInMotion
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//

import Foundation

struct Networking {
    let RADIUS = ConfigKeys.flickrAvailableRadius!
    
    func requestNewPicture(latitude: Double, longitude: Double, completionHandler: @escaping (Array<FlickrImage>) -> Void) {
        requestNewPicture(latitude: latitude, longitude: longitude,radius: RADIUS[0],  completionHandler: completionHandler)
    }
    func requestNewPicture(latitude: Double, longitude: Double, radius: Double,  completionHandler: @escaping (Array<FlickrImage>) -> Void) {
        let url = URL(string:
            "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(ConfigKeys.flickrApiKey!)&privacy_filter=1&content_type=4&has_geo=1&geo_context=2&lat=\(latitude)&lon=\(longitude)&radius=\(radius)&per_page=100&format=json&nojsoncallback=1")!
        let urlSession = URLSession.shared
        let getRequest = URLRequest(url: url)
        let task = urlSession.dataTask(with: getRequest as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                    let photos = json["photos"] as? [String: Any],
                    let photosArray = photos["photo"] as? [Any] {
                    if (photosArray.count > 0) {
                        let result = NSMutableArray()
                        for photo in photosArray {
                            result.add(FlickrImage(dictionary:photo as! [String:Any]))
                        }
                        if let response = result as NSArray as? [FlickrImage] {
                            completionHandler(response)
                        }
                    } else {
                        let index = self.RADIUS.index(of: radius)!+1
                        if (index < self.RADIUS.count){
                            self.requestNewPicture(latitude: latitude, longitude: longitude,radius: self.RADIUS[index],  completionHandler: completionHandler)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
