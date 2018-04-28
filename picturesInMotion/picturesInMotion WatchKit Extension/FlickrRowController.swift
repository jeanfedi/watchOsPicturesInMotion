//
//  FlickrRowController.swift
//  picturesInMotion
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//

import WatchKit

class FlickrRowController: NSObject {
    
    @IBOutlet var image: WKInterfaceGroup!
    
    var flickrImage: FlickrImage? {
        didSet {
            guard let flickrImage = flickrImage else { return }
            image.loadFromUrl(flickrImage.thumbnailUrl)
        }
    }
}

