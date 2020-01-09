//
//  ModelController.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 01/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import Foundation

// для передачи критериев по выводу услуг
class ModelController {
    var maleMan = "" // по дефолту будут все пола
    var partOfBody = "" // и все части тела
    var nameServiceCategory = ""
    var seatchTeg = ""
    
}

struct PersonAccount{
    let name: String
    let numberPhone: String
}

class ModelVCPerson{
    var person = PersonAccount(name: "", numberPhone: "")
}

