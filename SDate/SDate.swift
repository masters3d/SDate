//
//  SDate.swift
//  SDate
//
//  Created by cheyo on 9/19/15.
//  Copyright © 2015 masters3d All rights reserved.
//

import Darwin


struct SDate{
    
    enum DateFormatingOption {
        case yyyy_MM_dd
        case yyyy_MM_dd_T_HH_mm_ss
    }
    
    var descriptionStyle:DateFormatingOption = .yyyy_MM_dd
    
    private var tmDateBacking:tm = tm()
    
    var year:Int32 { return tmDateBacking.tm_year + 1900 }
    var month:Int32 { return tmDateBacking.tm_mon + 1 }
    var day:Int32 { return tmDateBacking.tm_mday }
    var hour:Int32 { return tmDateBacking.tm_hour }
    var mins:Int32 { return tmDateBacking.tm_min }
    var secs:Int32 { return tmDateBacking.tm_sec }
    var weekday:Int32 { return tmDateBacking.tm_wday + 1 }
    
    init(_ input:tm){
        self.tmDateBacking = input
    }
    
    init(){
        let temp = tm()
        SDate.init(temp).tmDateBacking
    }
    
    init(year:Int32, month:Int32, day:Int32, hour:Int32 = 0, mins:Int32 = 0, secs:Int32 = 0){
        var date = tm()
        date.tm_year = year - 1900
        date.tm_mon = month - 1
        date.tm_mday = day
        date.tm_hour = hour
        date.tm_min = mins
        date.tm_sec = secs
        
        // Automaticly sets the week day
        var d1 = timegm(&date)
        self.tmDateBacking = gmtime(&d1).memory
    }
    
    mutating func dateByAddingSeconds(seconds:Int) -> SDate {
        var d1 = timegm(&tmDateBacking) + seconds
        let d2 = gmtime(&d1).memory
        return SDate.init(d2)
    }
    
}

extension SDate:CustomStringConvertible {
    
    
    private func addLeadingZero(input:Int32) -> String {
        
        if (0...9).contains(input) {
            return "0\(input)" }
        else { return String(input) }
    }
    
    var description:String {
        
        let date = [year, month, day, hour, mins, secs].map{addLeadingZero($0)}
        
        let dateOnly = date[0] + "-" + date[1] + "-" + date[2]
        let dateTime = dateOnly + "T" + date[3] + ":" + date[4] + ":" + date[5]
        
        switch descriptionStyle{
        case .yyyy_MM_dd            : return dateOnly
        case .yyyy_MM_dd_T_HH_mm_ss : return dateTime
        }
    }
}

extension SDate{
    
    init?(from:String){
        guard let date = SDate.dateFromString(from) else { return nil }
        tmDateBacking = date.tmDateBacking
        if from.characters.count > 10 {
            self.descriptionStyle = .yyyy_MM_dd_T_HH_mm_ss
        }
    }
    
    static func dateFromString(input:String) -> SDate?  {
        var year = Int32()
        var month = Int32()
        var day = Int32()
        var hour = Int32()
        var minute = Int32()
        var second = Int32()
        
        let dateTime = input.characters.split("T").map{String($0)}
        let date = dateTime[0].characters.split("-").map{String($0)}
        if date.count == 3 {
            year = Int32(date[0]) ?? 0
            month = Int32(date[1]) ?? 0
            day = Int32(date[2]) ?? 0
        }
        
        if dateTime.count == 2 {
            let time = dateTime[1].characters.split(":").map{String($0)}
            if time.count == 3  {
                hour = Int32(time[0]) ?? 0
                minute = Int32(time[1]) ?? 0
                second = Int32(time[2]) ?? 0
                
            } }
        if year + month + day >= 3 {
            return SDate(year: year, month: month, day: day, hour: hour, mins: minute, secs: second)
            
        } else { return nil }
    }
}

