//
//  AllListServiceVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 01/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class AllListServiceVC: UIViewController {

    private var services: Results<Service>! // тип контейнера, который возвращает все объекты(массив)
    var arrayServises = Array<Service>() // массив с отобранными записями
    var humanMale = ""
    var modelController = ModelController()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = modelController.partOfBody
        
        services = realm.objects(Service.self) // берем все объекты типа Service
        deleteDuplicates(services: services) // вытаскиваем список для отображения всех service
        print("arrayServises.count ", arrayServises.count)
    }
    

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let detailServiceVC = segue.destination as? DetailServiceVC
        else {return}
        if identifire == "datailSegueAll"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
            detailServiceVC.service = arrayServises[indexPath.row]
        }
    }

}

// MARK: Work Table View
extension AllListServiceVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (arrayServises.count == 0) ? 0 : arrayServises.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCell
        
        
        cell.nameService.text = arrayServises[indexPath.row].nameService
        cell.price.text = "\(arrayServises[indexPath.row].placeService)"
        cell.timeService.text = arrayServises[indexPath.row].timeService
        
        return cell
    }
}
// MARK: Get array Service param
extension AllListServiceVC{
    private func deleteDuplicates(services: Results<Service>){
        switch (modelController.partOfBody == "AllPartOfBody") { // если перешли не с этого контроллера
        case true:
            self.title = "Список услуг"
            for service in services{ // выводим весь список услуг
                arrayServises.append(service)
                arrayServises = Array(Set<Service>(arrayServises))
            }
        case false:
            for service in services{
                if service.partOfTheBody == modelController.partOfBody
                    && (service.maleMan == modelController.maleMan
                        || service.maleMan == "unisex")
                { // отбор по части тела
                    arrayServises.append(service) // получаем все service
                }
            }
            arrayServises = Array(Set<Service>(arrayServises)) // убераем дубли
        }
    }
}
