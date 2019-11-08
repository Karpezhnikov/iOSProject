//
//  TwoListServiceVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 06/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryListServiceVC: UIViewController {

    private var services: Results<Service>! // тип контейнера, который возвращает все объекты(массив)
    var arrayServises = Array<Service>() // массив с отобранными записями
    var arrayNameServiceCategory = Array<String>()
    var modelController = ModelController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        services = realm.objects(Service.self) // берем все объекты типа Service
        deleteDuplicates(services: services) // вытаскиваем список для отображения всех service
        
        
    }
}

// MARK: Work these Controller View
extension CategoryListServiceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNameServiceCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width*0.4, height: UIScreen.main.bounds.size.height*0.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CustumCVC{
            itemCell.nameCotegoryService.text = arrayNameServiceCategory[indexPath.row]
            
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    // для получения нажатой ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // получаем выбраную категорию и записываем ее в модель контроллера
        modelController.nameServiceCategory = arrayNameServiceCategory[indexPath.item]
    }
}

//MARK: Navigation
extension CategoryListServiceVC{
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let samplePriceList = segue.destination as? SamplePriceListVC else {return}
        if identifire == "segueCategoryListService"{
            samplePriceList.modelController = modelController
        }

    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifire = segue.identifier, let detailServiceVC = segue.destination as? DetailServiceVC
//        else {return}
//        if identifire == "segueDetail"{
//            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
//            detailServiceVC.service = arrayServises[indexPath.row]
//        }
//    }
    
}

//MARK: Helpers func
extension CategoryListServiceVC{
    private func deleteDuplicates(services: Results<Service>){
        
        //self.navigationItem.title = "Список ус" // вставляем заголовок
        
        for service in services{ // выводим весь список услуг
            //arrayServises.append(service)
            arrayNameServiceCategory.append(service.nameCategoryService)
            //arrayServises = Array(Set<Service>(arrayServises))
            }
        
        arrayNameServiceCategory = Array(Set<String>(arrayNameServiceCategory)) // убераем дубли
    }
}

