//
//  InterfaceController.swift
//  picturesInMotion WatchKit Extension
//
//  Created by Phoedo on 28/04/18.
//  Copyright © 2018 Phoedo. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var picturesTable: WKInterfaceTable!
    @IBOutlet var startButton: WKInterfaceButton!
    
    var acquiring = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setStartButton()
        
        // Configure interface objects here.
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
        acquiring = true
        setStopButton()
    }
    
    func stopStandardUpdates(){
        acquiring = false
        setStartButton()
    }
    
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
    
    
    
}
