//
//  ChecklistItem.swift
//  Checklists
//
//  Created by пользователь on 27.01.17.
//  Copyright © 2017 Eugene Uskov. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    
    //--------------------------------------------------------------------------------------------

    
    var text = ""
    var checked = false

    // properties to work with notifications
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    
    //--------------------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------------------

    
    
    func toggleChecked() {
        
        checked = !checked
    }
    
    
    override init() {
        
        
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    //--------------------------------------------------------------------------------------------

    // methods to work with notifications
    
    // creating of local notification
    func scheduleNotification() {
        
        removeNotification()
        
        if shouldRemind && dueDate > Date() {

            let content = UNMutableNotificationContent()
            
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            // Extracting the month,day,hour,and minute from the dueDate
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            // shows the notification at the specified date
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // creating the notification
            let request = UNNotificationRequest(identifier: "\(itemID)",
                content: content, trigger: trigger)
            
            // adding the notification to the notification center
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    

    func removeNotification() {
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    
    deinit {
        
        removeNotification()
    }
    
    //--------------------------------------------------------------------------------------------

    // implementing NSCoding protocol
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        
        super.init()
    }
    
    
}
