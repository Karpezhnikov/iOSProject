//
//  ListCategoryVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class ListCategoryVC: UIViewController {
    
    var arrayServices: Results<Service>! // для передачи всей информации
    var service = Service() // для передачи выбраной ячейки
    var arrayCategoryServices = Array<String>() // для отображений массива з-й
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newArrayValues() // получаем список услуг
        self.title = service.comsmetology // всталяем название окна
        
        sampleServices(services: arrayServices) // получаем выборку CategoryService по comsmetology
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Work Table View
extension ListCategoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCategoryServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrayCategoryServices[indexPath.row]
        return cell
    }
}


extension ListCategoryVC{
    // MARK: Get array Service param
    
    private func sampleServices(services: Results<Service>){
        for value in services{
            if value.comsmetology == service.comsmetology{
                arrayCategoryServices.append(value.nameCategoryService)
            }
        }
        arrayCategoryServices = Array(Set<String>(arrayCategoryServices))
    }
}
