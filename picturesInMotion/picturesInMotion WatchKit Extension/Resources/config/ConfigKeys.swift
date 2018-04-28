//
//  ConfigKeys.swift
//  picturesInMotion
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//
import Foundation

struct ConfigKeys {
    static private let metersKey = "notificationMeters"
    static private let flickrApiKeyKey = "flickrApiKey"
    static private let flickrRadiusKey = "flickrAvailableRadius"
    static private let intervalBetweenRequestsKey = "waitIntervalBetweenRequests"
    static private let maxSessionIntervalKey = "maxSessionLength"

    static private let configPlistFilePath =  Bundle.main.path(forResource: "config", ofType: "plist")
    static private let configDictionary = NSDictionary(contentsOfFile: ConfigKeys.configPlistFilePath!) as? [String: Any]
    static let notificationMeters = ConfigKeys.configDictionary![ConfigKeys.metersKey] as? Double
    static let flickrApiKey = ConfigKeys.configDictionary![ConfigKeys.flickrApiKeyKey] as? String
    static let flickrAvailableRadius = ConfigKeys.configDictionary![ConfigKeys.flickrRadiusKey] as? [Double]
    static let intervelBetweenRequests = ConfigKeys.configDictionary![ConfigKeys.intervalBetweenRequestsKey] as? Int
    static let maxSessionInterval = ConfigKeys.configDictionary![ConfigKeys.maxSessionIntervalKey] as? Int


}
