//
//  SamplePriceListVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SamplePriceListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var newService = Service()
    
    let arrayPriceHead = ["Пластифицирующий массаж лица (без маски)",
                          "Пластифицирующий массаж лица + кремовая маска",
                          "Пластифицирующий массаж лица + альгинатная маска",
                          "Пластифицирующий массаж лица + растительная маска",
                          "Пластифицирующий массаж лица + гипсовая маска",
                          "Японский пластифицирующий массаж лица «Кобидо»",
                          "Японский пластифицирующий массаж лица «Кобидо» + пластифицирующая альгинатная маска по типу кожи",
                          "Японский пластифицирующий массаж лица «Кобидо» + гипсовая лифтинг-маска Gernetic",
                          "Японский пластифицирующий массаж лица «Кобидо» + гипсовая лифтинг-маска Academie"]
    let arrayCategori0 = ["ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ",
                          "УЛЬТРАЗВУКОВАЯ",
                          "ИНЪЕКЦИОННАЯ КОСМЕТОЛОГИЯ",
                          "АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА"]
    
    let arrayCategori = ["ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ. МАССАЖ ЛИЦА.",
                         "ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ. ЧИСТКА ЛИЦА.",
                         "УЛЬТРАЗВУКОВАЯ ЧИСТКА ЛИЦА.",
                         "ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ. УХОД ДЛЯ ЛИЦА.",
                         "ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ. ПИЛИНГ ЛИЦА.",
                         "ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ. ЭЛЕКТРОКОАГУЛЯЦИЯ ПАПИЛЛОМ И РОДИНОК.",
                         "ИНЪЕКЦИОННАЯ КОСМЕТОЛОГИЯ.",
                         "ИНЪЕКЦИОННАЯ КОСМЕТОЛОГИЯ. КОНТУРНАЯ ПЛАСТИКА.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА. ОЗОНОТЕРАПИЯ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА. BB GLOW TREATMENT. «ТОНАЛЬНЫЙ КРЕМ НА ГОД»",
                         "BB KISSUM LIPS «ЭФФЕКТ ЗАЦЕЛОВАННЫХ ГУБ»",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА. ФОТОТЕРАПИЯ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА. ЭЛЕКТРОПОРАЦИЯ. БЕЗИНЪЕКЦИОННАЯ МЕЗОТЕРАПИЯ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА. РАДИОВОЛНОВОЙ ЛИФТИНГ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА. ВАКУУМНЫЙ МАССАЖ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ТЕЛА. ОЗОНОТЕРАПИЯ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ТЕЛА. ПРЕССОТЕРАПИЯ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ТЕЛА. УЛЬТРАЗВУКОВАЯ КАВИТАЦИЯ.",
                         "АППАРАТНАЯ КОСМЕТОЛОГИЯ ТЕЛА. ВАКУУМНО-РОЛИКОВЫЙ МАССАЖ."]
    
    let arrayPrice = ["4500 тг.", "6000 тг.","7500 тг.","7500 тг.","7500 тг.","6000 тг.","9000 тг.","10000 тг.","12000 тг."]
    
    var priceList = StractSamplePriceList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("asdaasdss", priceList.humanMale)
        self.title = priceList.partOfBody
        
        
        
        
        
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCategori0.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCell
        if priceList.samplePriceList.count == 0 {
            // todo: должен вернуться массив с всем прайсом
        }
        //cell.textLabel?.text = priceList.samplePriceList[indexPath.row]
        //cell.typeOfService.text = priceList.samplePriceList[indexPath.row]
        cell.typeOfService.text = arrayCategori0[indexPath.row]
        
        return cell
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let listCategoryVC = segue.destination as? ListCategoryVC
        else {return}
        if identifire == "listCategorySegue"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
            // создаем экземпляр класса по нужному индексу
//            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
//            let newPlaceVC = segue.destination as! NewPlaceViewController // создаем связть с другим вью
//            newPlaceVC.currentPlace = place
            listCategoryVC.titleView = arrayCategori0[indexPath.row]
        }
    }
    
}
