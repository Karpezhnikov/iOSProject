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

    var categoryService: Results<CategoryService>!
    var modelSamplePriceListVC = ModelSamplePriceListVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //services = realm.objects(Service.self) // берем все объекты типа Service
        //deleteDuplicates(services: services) // вытаскиваем список для отображения всех service
        categoryService = realm.objects(CategoryService.self).sorted(byKeyPath: "category")
        //print(category)
    }
}



//MARK: Navigation
extension CategoryListServiceVC{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let samplePriceList = segue.destination as? SamplePriceListVC else {return}
        if identifire == "segueCategoryListService"{
            samplePriceList.modelSamplePriceListVC = self.modelSamplePriceListVC
        }
    }
}


//MARK: Table View
extension CategoryListServiceVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as! CategoryTVCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.nameCategory.text = categoryService[indexPath.row].category
        if let dataImage = categoryService[indexPath.row].image{
            cell.imageCategory.image = UIImage(data: dataImage)
        }else{
            cell.imageCategory.image = UIImage(named: "launchScr")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryService[indexPath.row].category == "Все услуги"{
            modelSamplePriceListVC.category = ""
        }else{
            modelSamplePriceListVC.category = categoryService[indexPath.row].category
        }
        modelSamplePriceListVC.titleController = categoryService[indexPath.row].category
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
}

