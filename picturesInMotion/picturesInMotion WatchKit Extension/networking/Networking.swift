//
//  Networking.swift
//  picturesInMotion
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//

import Foundation

struct Networking {
    func requestNewPicture(latitude: Double, longitude: Double, completionHandler: @escaping (FlickrImage) -> Void) {        
        let url = URL(string:
            "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(ConfigKeys.flickrApiKey!)&privacy_filter=1&content_type=4&has_geo=1&geo_context=2&lat=\(latitude)&lon=\(longitude)&radius=10&per_page=1&format=json&nojsoncallback=1")!
        NSLog("URL \(url)")
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
                    let photosArray = photos["photo"] as? [Any],
                    let photo = photosArray[0] as? [String : Any] {
                        completionHandler(FlickrImage(dictionary:photo))
                        NSLog("SENDING NEW PICTURE")
                    }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
}
