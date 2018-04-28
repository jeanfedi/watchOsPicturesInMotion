//
//  InterfaceController.swift
//  picturesInMotion WatchKit Extension
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    
    @IBOutlet var picturesTable: WKInterfaceTable!
    @IBOutlet var startButton: WKInterfaceButton!
    
    var acquiring = false
    let locationManager: CLLocationManager = CLLocationManager()
    var lastLocation : CLLocation? = nil
    let uploadedImages = NSMutableArray()
    var canUpdateList = true
    var maximumLengthTimer : Timer? = nil

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        if (!WCSession.isSupported()){
            setDisconnectedButton()
        }
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = ConfigKeys.notificationMeters! // In meters.
        locationManager.requestWhenInUseAuthorization()

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        picturesTable.scrollToRow(at: 0)
    }
    
    @IBAction func toggleStartStopButton(v: WKInterfaceButton){
        if (acquiring){
            stopStandardUpdates()
        } else {
            startStandardUpdates()
        }
    }
    
    func startStandardUpdates(){
        if (picturesTable.numberOfRows > 0){
            picturesTable.removeRows(at: IndexSet(0...picturesTable.numberOfRows-1) )
        }
        maximumLengthTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(ConfigKeys.maxSessionInterval!), repeats: false, block: {_ in
            self.stopStandardUpdates()
        })

        self.uploadedImages.removeAllObjects()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            locationManager.startUpdatingLocation()
            acquiring = true
            setStopButton()
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            acquiring = true
            //locationManager.startUpdatingHeading()
        }
    }
    
    func stopStandardUpdates(){
        acquiring = false
        setStartButton()
        locationManager.stopUpdatingLocation()
        maximumLengthTimer?.invalidate()
    }
    
    // MARK: locationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (WCSession.isSupported() && (status==CLAuthorizationStatus.authorizedAlways || status==CLAuthorizationStatus.authorizedWhenInUse)){
            if (!acquiring){
                setStartButton()
            } else {
                startStandardUpdates()
            }
        } else {
            setLocationDisabledButton()
            if (acquiring){
                stopStandardUpdates()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        var addNewImage = true
        if (lastLocation != nil){
            if (lastLocation!.distance(from: userLocation) == 0){
                addNewImage = false;
            }
        }
        lastLocation = userLocation
        if (addNewImage){
            if (canUpdateList){
                canUpdateList = false
                Timer.scheduledTimer(withTimeInterval: TimeInterval(ConfigKeys.intervelBetweenRequests!), repeats: false, block: {_ in
                    self.canUpdateList = true
                })
                Networking().requestNewPicture(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, completionHandler: { flickrImages in
                var loaded = false
                    for flickrImage in flickrImages {
                        if (!self.uploadedImages.contains(flickrImage.id)){
                            self.addNewRecord(flickrImage: flickrImage)
                            loaded = true
                            break
                        }
                    }
                    if (!loaded && flickrImages.count > 0){
                        self.uploadedImages.removeAllObjects()
                        self.addNewRecord(flickrImage: flickrImages[0])
                    }
                })
            }
        }
    }
    
    // MARK: buttonStyles
    
    func setStartButton(){
        startButton.setTitle(NSLocalizedString(StringKeys.startMessage, comment: ""))
        startButton.setBackgroundColor(UIColor.green)
        startButton.setEnabled(true)
    }
    
    func setStopButton(){
        startButton.setTitle(NSLocalizedString(StringKeys.stopMessage, comment: ""))
        startButton.setBackgroundColor(UIColor.red)
        startButton.setEnabled(true)
    }
    
    func setDisconnectedButton(){
        startButton.setTitle(NSLocalizedString(StringKeys.disconnectedMessage, comment: ""))
        startButton.setBackgroundColor(UIColor.gray)
        startButton.setEnabled(false)
    }
    
    func setLocationDisabledButton(){
        startButton.setTitle(NSLocalizedString(StringKeys.locationDisabledMessage, comment: ""))
        startButton.setBackgroundColor(UIColor.gray)
        startButton.setEnabled(false)
    }
    
    func addNewRecord(flickrImage:FlickrImage){
        uploadedImages.add(flickrImage.id)
        self.picturesTable.insertRows(at:[0], withRowType: "FlickrImageRow")
        guard let controller = self.picturesTable.rowController(at: 0) as? FlickrRowController else {return}
        controller.flickrImage = flickrImage
        
    }
    
    
    
}
