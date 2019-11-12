//
//  DetailServiceVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 31/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class DetailServiceVC: UIViewController {

    var service = Service()
    private var masters = [MasterServices]()
    
    @IBOutlet weak var nameDeteilService: UILabel!
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameDeteilService.text = service.nameService
        callButton.layer.cornerRadius = 10
        singUpButton.layer.cornerRadius = 10
        setupNavigationBar()
        
        getMasterFromTheDataBase() // заполняем массив masters
        
        //ToDo: доделать вывод мастеров на экран
        
        
    }
    // MARK: Get Data From The DataBase
    private func getMasterFromTheDataBase(){
        let idsMaster = service.idsMasters.components(separatedBy: ";") // парсим строку для получения id
        guard idsMaster.count > 0 else { // проверием что они есть
            return
        }
        let listMasters = realm.objects(MasterServices.self) // делаем запрос в бд
        for master in listMasters{
            if idsMaster.contains(master.idMaster) { // берем нужных мастеров
                masters.append(master)
            }
        }
    }
    
    // MARK: SetupNavigationBar
    private func setupNavigationBar(){
        // настраиваем кнопку назад
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            //topItem.backBarButtonItem?.image = UIImage(named: "leftBarButton")
            let imgBackArrow = UIImage(named: "leftBarButton")

            navigationController?.navigationBar.backIndicatorImage = imgBackArrow
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        }
        
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
extension DetailServiceVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCellDetail
        
        cell.nameMaster.text = masters[indexPath.row].nameMaster
        cell.serviceMaster.text = masters[indexPath.row].listServicesMaster
        cell.timeAndPriceMaster.text = "\(service.timeService), \(service.placeService)"
        cell.photoMaster.image = UIImage(named: "firstPageIcon")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
}
