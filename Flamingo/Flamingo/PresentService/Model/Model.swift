//
//  Model.swift
//  Flamingo
//
//  Created by mac on 28/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
var month = calendar.component(.month, from: date) - 1 // -1 потому что берем название месяца из массива
var year = calendar.component(.year, from: date)

let firstDayComponents = calendar.dateComponents([.year, .month], from: date)
let firstDay = calendar.date(from: firstDayComponents)!
let firstWeekday = calendar.component(.weekday, from: firstDay)

//MARK: Date Formater
 func dateFromString (dateStr: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let date = dateFormatter.date(from: dateStr)
    return date
}
