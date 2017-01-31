//
//  DataModel.swift
//  Checklists
//
//  Created by пользователь on 30.01.17.
//  Copyright © 2017 Eugene Uskov. All rights reserved.
//

import Foundation

class DataModel {
    
    //--------------------------------------------------------------------------------------------
    
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }

    
    //--------------------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------------------

    
    init() {
        
        loadChecklists()
        registerDefaults()
        handleFirstTime()
        
    }
    

    class func nextChecklistItemID() -> Int {
        
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
    

    
    func sortChecklists() {
        
        // sort without considering capital letters
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
    
    
    // add new records to Info.plist
    func registerDefaults() {
        
        let dictionary: [String: Any] = [ "ChecklistIndex": -1,
                                          "FirstTime": true,
                                          "ChecklistItemID": 0 ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    
    func handleFirstTime() {
        
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            
            let checklist = Checklist(name: "List")
            
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    
    
    //--------------------------------------------------------------------------------------------
    
    // work with files
    
    
    
    // is used to get the full path to the Documents folder
    func documentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    
    // is used to construct the full path to the file(Checklists.plist) that will store the apps data
    func dataFilePath() -> URL {
        
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    
    
    // encodes data and saves it in "Cheklists.plist"
    func saveChecklists() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        
        data.write(to: dataFilePath(), atomically: true)
    }
    
    
    
    func loadChecklists() {
        
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            
            sortChecklists()
        }
    }
    
    
    //--------------------------------------------------------------------------------------------
}
