//
//  SampleServiceEmptyVC.swift
//  Flamingo
//
//  Created by mac on 24/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class SampleServiceEmptyVC: UIViewController {
    
    let arrayServiceEntry = realm.objects(ServiceEntry.self)
    var indexPathPresent = IndexPath()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func actionCancellaration(_ sender: Any) {
    }
    
    
    @IBAction func actionOverwrite(_ sender: Any) {
    }
    
    @IBAction func actionPresentService(_ sender: Any) {
        //определяем indexPath ячейки в которой нажата кнопка
        guard let indexPath = tableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint(), to: tableView)) else {
            return
        } // определяем индекс строки
        indexPathPresent = indexPath
    }
    
    @IBAction func actionPresentMaster(_ sender: Any) {
        //определяем indexPath ячейки в которой нажата кнопка
        guard let indexPath = tableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint(), to: tableView)) else {
            return
        } // определяем индекс строки
        indexPathPresent = indexPath
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier else {return}
        if identifire == "presentMaster"{
            let master = realm.objects(Master.self).filter("id CONTAINS[c] %@", arrayServiceEntry[indexPathPresent.row].idMaster)
            guard let destinationVC = segue.destination as? AddNewMasterVC else {return}
            guard master.count != 0 else {return}
            destinationVC.master = master.first!
            destinationVC.viewFlg = true
            
        }
        if identifire == "presentService"{
            let service = realm.objects(Service.self).filter("id CONTAINS[c] %@", arrayServiceEntry[indexPathPresent.row].serviceIdDocument)
            guard service.count != 0 else {return}
            guard let detailServiceVC = segue.destination as? DetailServiceVC else{return}
            detailServiceVC.service = service.first!
        }
        
    }

}

extension SampleServiceEmptyVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayServiceEntry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceEnryTVCell
        cell.nameService.text = arrayServiceEntry[indexPath.row].serviceName
        cell.labelMaster.text = "Специалист"
        let idMaster = arrayServiceEntry[indexPath.row].idMaster
        let master = realm.objects(Master.self).filter("id CONTAINS[c] %@", idMaster)
        if master.count != 0{
            cell.nameMaster.text = master.first?.name
        }else{
            cell.nameMaster.text = ""
        }
        cell.timeServiceEntry.text = arrayServiceEntry[indexPath.row].dttmEntry
        
        return cell
    }
    
    
}
