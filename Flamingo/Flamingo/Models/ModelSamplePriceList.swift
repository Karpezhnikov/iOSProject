//
//  ModelSamplePriceList.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

//Тут будет описана модель загрузки данных при входе на SamplePriceList

import Foundation

struct StractSamplePriceList {
    var samplePriceList = Array<String>() // список услуг(в зависомости от выбора ЧТ)
    var humanMale = String() // пол человека
    var partOfBody = String() // часть тела человека
}

