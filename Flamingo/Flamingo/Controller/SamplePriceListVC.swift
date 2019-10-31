//
//  SamplePriceListVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class SamplePriceListVC: UIViewController{
    
    private var services: Results<Service>! // тип контейнера, который возвращает запрашиваемые объекты(массив)
    var arrayComsmetology = StractSamplePriceList()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = arrayComsmetology.partOfBody // Вставляем часть тела в title окна
        
        services = realm.objects(Service.self) // берем все объекты типа Service
        deleteDuplicates(services: services) // вытаскиваем список для отображения всех comsmetology
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let listCategoryVC = segue.destination as? ListCategoryVC
        else {return}
        if identifire == "listCategorySegue"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
            listCategoryVC.service.comsmetology = arrayComsmetology.samplePriceList[indexPath.row]// передаем comsmetology
            listCategoryVC.arrayServices = services // передаем все данные из базу, что не дергать БД
        }
    }
    
}

// MARK: Work Table View
extension SamplePriceListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayComsmetology.samplePriceList.isEmpty ? 0 : arrayComsmetology.samplePriceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCell
        cell.typeOfService.text = arrayComsmetology.samplePriceList[indexPath.row]
        return cell
    }
}

// MARK: Get array Service param
extension SamplePriceListVC{
    private func deleteDuplicates(services: Results<Service>){
        for service in services{
            if service.partOfTheBody == arrayComsmetology.partOfBody{ // отбор по части тела
                arrayComsmetology.samplePriceList.append(service.comsmetology) // получаем все comsmetology
            }
        }
        arrayComsmetology.samplePriceList = Array(Set<String>(arrayComsmetology.samplePriceList)) // убераем дубли
    }
}
