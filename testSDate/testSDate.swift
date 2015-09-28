//
//  testSDate.swift
//  testSDate
//
//  Created by cheyo on 9/19/15.
//  Copyright © 2015 masters3d All rights reserved.
//

import XCTest

func newNSDate(input:String, format : String = "yyyy-MM-dd") -> NSDate {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return dateFormatter.dateFromString(input) ?? NSDate.distantFuture()
}

class SDateTest: XCTestCase {
    
    func test1AddingSeconds () {
        let gs = SDate(fromString: "2011-04-25T00:00:00")?.dateByAddingSeconds(1_000_000_000).description
        XCTAssertEqual("2043-01-01T01:46:40", gs)
    }
    
    func test2AddingSeconds () {
        let gs = SDate(fromString: "1977-06-13T00:00:00")?.dateByAddingSeconds(1_000_000_000).description
        XCTAssertEqual("2009-02-19T01:46:40", gs)
    }
    
    func test3AddingSeconds () {
        let gs = SDate(fromString: "1959-07-19T00:00:00")?.dateByAddingSeconds(1_000_000_000).description
        XCTAssertEqual("1991-03-27T01:46:40", gs)
    }
    
    func testTimeWithSeconds () {
        let gs = SDate(fromString: "1959-07-19T23:59:59")?.dateByAddingSeconds(1_000_000_000).description
        XCTAssertEqual("1991-03-28T01:46:39", gs)
    }
    
    func testSameTime () {
        let gs = SDate(fromString: "1959-07-19")?.description
        var s = newNSDate("1959-07-19").description.characters.split(" ").map{String($0)}
        XCTAssertEqual(s[0], gs)
    }
    
    func testdateSince1970 () {
        let gs = Int(SDate(fromString: "1959-07-19")?.secondsSince1970 ?? 0 )
        let s = Int(newNSDate("1959-07-19").timeIntervalSince1970)
        XCTAssertEqual(s, gs)
    }
    
    func testDistantFuture(){
        XCTAssertEqual(Double(NSDate.distantFuture().timeIntervalSince1970) , SDate.distantFuture().secondsSince1970)

    }
    

    
    
}


