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
    }
    
    @IBAction func toggleStartStopButton(v: WKInterfaceButton){
        if (acquiring){
            stopStandardUpdates()
        } else {
            startStandardUpdates()
        }
    }
    
    func startStandardUpdates(){
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
        NSLog("Authorization \(status.rawValue)")
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        if (lastLocation != nil){
            NSLog("Distance: \(lastLocation!.distance(from: userLocation))")
        }
        lastLocation = userLocation
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
    
    
    
}
