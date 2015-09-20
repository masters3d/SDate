//
//  SDate.swift
//  SDate
//
//  Created by cheyo on 9/19/15.
//  Copyright © 2015 masters3d All rights reserved.
//

import Darwin

extension tm{
    mutating func setMissingValues(){
        var d1 = timegm(&self)
        self = gmtime(&d1).memory
    }
}


struct SDate{
    
    enum DateFormatingOptions {
        case yyyy_MM_dd
        case yyyy_MM_dd_T_HH_mm_ss
    }
    
    var descriptionStyleToUse:DateFormatingOptions = .yyyy_MM_dd
    
    private var tmDateBacking:tm = tm()
    
    var year:Int { return Int(tmDateBacking.tm_year + 1900) }
    var month:Int { return Int(tmDateBacking.tm_mon + 1) }
    var day:Int { return Int(tmDateBacking.tm_mday) }
    var hour:Int { return Int(tmDateBacking.tm_hour)}
    var mins:Int { return Int(tmDateBacking.tm_min) }
    var secs:Int { return Int(tmDateBacking.tm_sec) }
    var weekday:Int { return Int(tmDateBacking.tm_wday + 1 ) }
    
    init(){
        
        var temp = time_t()
        var localTime = localtime(&temp).memory
        localTime.setMissingValues()
        
        self.tmDateBacking = localTime
    }
    
    init(year:Int, month:Int, day:Int, hour:Int = 0, mins:Int = 0, secs:Int = 0){
        var date = tm()
        date.tm_year = Int32(year - 1900)
        date.tm_mon = Int32(month - 1)
        date.tm_mday = Int32(day)
        date.tm_hour = Int32(hour)
        date.tm_min = Int32(mins)
        date.tm_sec = Int32(secs)
        
        // Automaticly sets the week day
        date.setMissingValues()
        
        self.tmDateBacking = date
    }
    
    func dateByAddingSeconds(seconds:Int) -> SDate {
        var temp = tmDateBacking
        var d1 = timegm(&temp) + seconds
        let d2 = gmtime(&d1).memory
        var newDate = SDate()
        newDate.tmDateBacking = d2
        newDate.descriptionStyleToUse = self.descriptionStyleToUse
        return newDate
    }
    
}

extension SDate:CustomStringConvertible {
    
    private func addLeadingZero(input:Int) -> String {
        
        if (0...9).contains(input) {
            return "0\(input)" }
        else { return String(input) }
    }
    
    var description:String {
        
        let date = [year, month, day, hour, mins, secs].map{addLeadingZero($0)}
        
        let dateOnly = date[0] + "-" + date[1] + "-" + date[2]
        let dateTime = dateOnly + "T" + date[3] + ":" + date[4] + ":" + date[5]
        
        switch descriptionStyleToUse{
        case .yyyy_MM_dd            : return dateOnly
        case .yyyy_MM_dd_T_HH_mm_ss : return dateTime
        }
    }
}

extension SDate{
    
    init?(fromString:String){
        guard let date = SDate.dateFromString(fromString) else { return nil }
        tmDateBacking = date.tmDateBacking
        if fromString.characters.count > 10 {
            self.descriptionStyleToUse = .yyyy_MM_dd_T_HH_mm_ss
        }
    }
    
    static func dateFromString(input:String) -> SDate?  {
        var year = Int()
        var month = Int()
        var day = Int()
        var hour = Int()
        var minute = Int()
        var second = Int()
        
        let dateTime = input.characters.split("T").map{String($0)}
        var date = [String]()
        if dateTime.count > 0 {
            date = dateTime[0].characters.split("-").map{String($0)}
            if date.count >= 3 {
                year = Int(date[0]) ?? 0
                month = Int(date[1]) ?? 0
                day = Int(date[2]) ?? 0
            }
        }
        
        if dateTime.count >= 2 {
            let time = dateTime[1].characters.split(":").map{String($0)}
            if time.count >= 3  {
                hour = Int(time[0]) ?? 0
                minute = Int(time[1]) ?? 0
                second = Int(time[2]) ?? 0
                
            } }
        if year + month + day >= 3 {
            return SDate(year: year, month: month, day: day, hour: hour, mins: minute, secs: second)
            
        } else { return nil }
    }
}

