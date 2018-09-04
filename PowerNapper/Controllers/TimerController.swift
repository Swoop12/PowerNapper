//
//  TimerController.swift
//  PowerNapper
//
//  Created by DevMountain on 9/4/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import UserNotifications

//Define the protocol (list out the requirements to be the boss)
protocol TimerControllerDelegate: class{
    
    func timerSecondTick()
    func timerCompleted()
    func timerStopped()
    
}

class TimerController{
    
    let identifier = "NotificationID"
    
    var timeRemaining: TimeInterval?
    var timer: Timer?
    
    var isOn: Bool {
        if timeRemaining != nil{
            return true
        }else {
            return false
        }
    }
    
    //2.) Define Weak var delegate. (the child recognizing a place a heart where it needs a boss ; a hook)
    weak var delegate: TimerControllerDelegate?
    
    func secondTick(){
        guard let timeRemaining = timeRemaining else {return}
        if timeRemaining > 0{
            self.timeRemaining = timeRemaining - 1
            print(timeRemaining)
            delegate?.timerSecondTick()
        }else {
            timer?.invalidate()
            self.timeRemaining = nil
            delegate?.timerCompleted()
        }
    }
    
    func startTimer(time: TimeInterval){
        if !isOn{
            timeRemaining = time
            scheduleLocalNotification()
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.secondTick()
                })
            }
        }
    }
    
    func stopTimer(){
        if isOn{
            timer?.invalidate()
            timeRemaining = nil
            cancelLocalNotification()
            delegate?.timerStopped()
        }
    }
    
    
    func timeAsString() -> String{
        let timeRemaining = Int(self.timeRemaining ?? 20*60)
        let minutes = timeRemaining / 60
        let seconds = timeRemaining - (minutes * 60)
        
        return String(format: "%02d : %02d", arguments: [minutes, seconds])
    }
    
    func scheduleLocalNotification(){
        
        let content = UNMutableNotificationContent()
        content.title = "Wake UP!"
        content.body = "No... Seriously Wake up. You late for work."
        
        guard let timeRemaining = timeRemaining else {return}
        
        let date = Date(timeInterval: timeRemaining, since: Date())
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
            }
        }
    }
    
    func cancelLocalNotification(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
