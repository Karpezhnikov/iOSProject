//
//  SetupDataPicker.swift
//  Flamingo
//
//  Created by mac on 18/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupDataPicker: UIDatePicker {

    //var timeAndDate = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.datePickerMode = .dateAndTime //запись даты и времени
        let localeID = Locale.preferredLanguages.first // определяем локацию для времени
        self.locale = Locale(identifier: localeID!) // устанавливаем локацию в dataPIcker
        //self.addTarget(self, action: #selector(dateChanged), for: .valueChanged) // тригер срабатывает при изменении значения в datePicker
        self.maximumDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) // минимальная дата = данное время + 2 xfcf
        self.maximumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) // максимальная данное время + 30 дней
    }

//    func getDateFromPicker()-> String{
//        let formatter = DateFormatter() //  создаем форматер
//        formatter.dateFormat = "EEEE, dd.MM, HH:mm" // создаем формат даты и времени
//        return formatter.string(from: self.date)
//    }

}
