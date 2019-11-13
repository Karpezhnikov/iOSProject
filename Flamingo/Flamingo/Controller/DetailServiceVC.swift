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

    var service = Service() // выбраная услуга
    private var masters = [MasterServices]() // для списка всех мастеров
    
    
    @IBOutlet weak var nameDeteilService: UILabel!
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        masters = StorageManager.getMasterFromTheDataBase(service) // получаем всех мастеров для услуги
        nameDeteilService.text = service.nameService // устанавливаем заголовок
    
    }

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
