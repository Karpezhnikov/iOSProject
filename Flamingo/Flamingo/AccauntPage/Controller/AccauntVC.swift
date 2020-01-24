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
    
    private func fillInTheData(){
        let namePersonDefault = UserDefaults.standard.string(forKey: "namePerson")
        let numberPersonDefault = UserDefaults.standard.string(forKey: "numberPerson")
        if numberPersonDefault == nil{
            logInUIView.isHidden = false
            namePerson.text = ""
            numberPerson.text = ""
        }else{
            logInUIView.isHidden = true
            namePerson.text = namePersonDefault
            numberPerson.text = numberPersonDefault
        }
        
        //посмотреть систему бонусов
        bonusPerson.text = "0"
        // сделать записи активными и нет
        activeAppointments.text = "0"
        //
        
        allAppointsments.text = "\(arrayServiceEntry.count)"
        favoritesService.text = "\(arrayServiceFavorites.count)"
        
        imagePerson.imageCornerRadiusPlusBorder()
    }


}
