//
//  AccauntVC.swift
//  Flamingo
//
//  Created by mac on 23/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class AccauntVC: UIViewController {

    let arrayServiceEntry = realm.objects(ServiceEntry.self)
    let arrayServiceFavorites = realm.objects(Service.self).filter("favorites = \(true)")
    
    @IBOutlet weak var imagePerson: UIImageView!
    
    @IBOutlet weak var numberPerson: UILabel!
    @IBOutlet weak var namePerson: UILabel!
    
    @IBOutlet weak var bonusPerson: UILabel!
    
    @IBOutlet weak var activeAppointments: UILabel!
    @IBOutlet weak var allAppointsments: UILabel!
    @IBOutlet weak var favoritesService: UILabel!
    
    @IBOutlet weak var logInUIView: CustomUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInTheData()
        
    }
    
    //presentFavorites
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let samplePriceList = segue.destination as? SamplePriceListVC else {return}
        if identifire == "presentFavorites"{
            samplePriceList.modelSamplePriceListVC.presentFavorites = true
            samplePriceList.modelSamplePriceListVC.titleController = "Избранное"
        }
    }
    
    @IBAction func unwindToAccauntVC(_ unwindSegue: UIStoryboardSegue) {
        fillInTheData()
    }
    
    private func fillInTheData(){
        //проверяем если ли аккаунт
        let persons = realm.objects(Person.self)
        if persons.count > 0{
            guard let person = persons.first else{return}
            namePerson.text = person.name
            numberPerson.text = person.numberPhone
            logInUIView.isHidden = true
        }else{
            logInUIView.isHidden = false
            namePerson.text = ""
            numberPerson.text = ""
        }
        
        //посмотреть систему бонусов
        bonusPerson.text = "0"
        activeAppointments.text = "\(countActiveEntry())"
        allAppointsments.text = "\(arrayServiceEntry.count)"
        favoritesService.text = "\(arrayServiceFavorites.count)"
        
        imagePerson.imageCornerRadiusPlusBorder()
    }


    private func countActiveEntry()->Int{
        var countActiveEntry = 0
        for sample in arrayServiceEntry{
            if sample.dttmEntry > Date(){
                countActiveEntry += 1
            }
        }
        return countActiveEntry
    }
    
}
