//
//  ViewController.swift
//  PowerNapper
//
//  Created by DevMountain on 9/4/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

//4) Adopt the protocol
class ViewController: UIViewController, TimerControllerDelegate {
    
    //5) Conform to the protocol and write implementaions of its functions
    func timerSecondTick() {
        timeLabel.text = timerController.timeAsString()
    }
    
    func timerCompleted() {
        updateView()
        presentSnoozeAlertController()
    }
    
    func timerStopped() {
        updateView()
    }
    
    func presentSnoozeAlertController(){
        let alertController = UIAlertController(title: "Snooze?", message: "If you're feeling lazy go-head add a few more seconds", preferredStyle: .alert)
        alertController.addTextField { (snoozeTextField) in
            snoozeTextField.placeholder = "Snooze"
            snoozeTextField.keyboardType = .numberPad
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { (_) in
            guard let snoozeTimeString = alertController.textFields?.first?.text else {return}
            guard let snoozeTime = TimeInterval(snoozeTimeString) else {return}
            self.timerController.startTimer(time: snoozeTime)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(snoozeAction)
        
        present(alertController, animated: true)
        
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var toggleTimerButton: UIButton!
    
    let timerController = TimerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the childs delegate property = self
        timerController.delegate = self
    }
    
    func updateButton(){
        if timerController.isOn{
            toggleTimerButton.setTitle("Stop Timer", for: .normal)
        }else {
            toggleTimerButton.setTitle("Start Timer", for: .normal)
        }
    }
    
    func updateView(){
        timeLabel.text = timerController.timeAsString()
        updateButton()
    }

    @IBAction func timmerToggled(_ sender: Any) {
        if timerController.isOn{
            timerController.stopTimer()
        }else{
           timerController.startTimer(time: 10)
        }
        updateView()
    }
    
}

