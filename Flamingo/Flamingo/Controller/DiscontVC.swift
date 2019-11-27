//
//  DescontVC.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase


class DiscontVC: UIViewController {

    private var disconts: Results<Discount>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ////////////////////////////
//        let db = Firestore.firestore()
//        // запись в FireBase
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
//        ref = db.collection("users").addDocument(data: [
//            "first": "Alan",
//            "middle": "Mathison",
//            "last": "Turing",
//            "born": 1912
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        // Получение данных из FireBase
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
        
        
        //////////////////////////
        disconts = realm.objects(Discount.self) // получаем все акции
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let detailDiscontVC = segue.destination as? DetailDiscontVC
        else {return}
        if identifire == "detailDiscont"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
            detailDiscontVC.discont = disconts[indexPath.row]
            //detailServiceVC.service = arrayServises[indexPath.row]
        }
    }
    
}



// MARK: Work these TableView
extension DiscontVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disconts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDiscont", for: indexPath) as! CustomTVCellDiscont
        
        
        
        cell.nameDiscount = disconts[indexPath.row].nameDiscount
        cell.descriptionDiscount = disconts[indexPath.row].descriptionDiscount
        cell.imageDiscont.image = UIImage(data: disconts[indexPath.row].image!)
        
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width // делаем высоту равной ширине ячейки
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
}
