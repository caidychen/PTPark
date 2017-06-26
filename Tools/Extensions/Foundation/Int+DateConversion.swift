//
//  Int+DateConversion.swift
//  PTPark
//
//  Created by CHEN KAIDI on 17/5/2017.
//
//

import Foundation

public extension Int {

    //Example time format: "YYYY/MM/dd hh:mm:ss"
    func convertToDate(format:String) -> String{
        let date = NSDate(timeIntervalSince1970: Double(self))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    func countdownDays() -> (Int){
        let now = Date()
        let timestamp = Int(now.timeIntervalSince1970)
        let difference = self - timestamp
        return difference / 60 / 60 / 24
    }
    
}
