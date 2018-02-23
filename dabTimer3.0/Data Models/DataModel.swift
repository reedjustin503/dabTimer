//
//  DataModel.swift
//  dabTimer3.0
//
//  Created by Adam Reed on 2/18/18.
//  Copyright © 2018 RD concepts. All rights reserved.
//

import Foundation


class DataModel {
    
    var lists = [TimerListItem]()
    
    var indexOfSelectedTimerlist: Int {
        
        get {
            return UserDefaults.standard.integer(forKey: "TimerListIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TimerListIndex")
        }
        
    }
    
    init() {
        loadCheckLists()
        registerDefaults()
        handleFirstTime()
    }

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("timer.plist")
    }
    
    func saveTimerLists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array.")
        }
    }
    
    func loadCheckLists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([TimerListItem].self, from: data)
                sortTimerlists()
            } catch {
                print("Error decoding items array.")
            }
        }
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let timerListItem = TimerListItem(name: "Default Timer")
            let newTimer = UpDownTimer()
            newTimer.name = "Default Name"
            timerListItem.items.append(newTimer)
            lists.append(timerListItem)
            
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
        
    }
    
    func registerDefaults() {
        let dictionary: [ String: Any ] = [ "TimerListIndex": -1 ,
                           "FirstTime": true ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    
    func sortTimerlists() {
        lists.sort(by:{ timerlist1, timerlist2 in
            return timerlist1.name.localizedCompare(timerlist2.name) == .orderedAscending })
    }
    
}
