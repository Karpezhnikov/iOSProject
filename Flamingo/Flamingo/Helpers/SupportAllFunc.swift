//
//  SupportAllFunc.swift
//  Flamingo
//
//  Created by mac on 29/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import Foundation

class WorkTimeAndDate{
    
    //MARK:dateFromString
    // переводит из теста в дату
    static func dateFromString(dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    //MARK:dateFromConvert
    // переводит в стринг из даты (в нужную структура даты)
    static func dateFromConvert(_ date: Date, mask: String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = mask
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
