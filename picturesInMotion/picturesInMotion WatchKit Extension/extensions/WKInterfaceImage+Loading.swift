//
//  WKInterfaceImage+Loading.swift
//  picturesInMotion
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//

import WatchKit

extension WKInterfaceGroup {
    public func loadFromUrl(_ urlString: String) {
        
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let imageData = data as Data? {
                    DispatchQueue.main.async {
                        self.setBackgroundImageData(imageData)
                    }
                }
            });
            task.resume()
        }
    }
}
