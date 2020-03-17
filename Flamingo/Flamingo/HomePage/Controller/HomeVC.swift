//
//  HomeVC.swift
//  Flamingo
//
//  Created by mac on 17/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class HomeVC: UIViewController {


    let spacing = CGFloat(0)
    let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
    let arrayPhotoDesign = [UIImage(named: "f39"), UIImage(named: "f40"),
                UIImage(named: "f41"), UIImage(named: "f46"),
                UIImage(named: "f47"), UIImage(named: "f49"),
                UIImage(named: "f53"), UIImage(named: "f54"),
                UIImage(named: "f56"), UIImage(named: "f80")]
    private var masters: Results<Master>!{
        didSet{
            collectionViewMasters.reloadData()
        }
    }
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var buttomMaster: UIButton!
    @IBOutlet weak var buttonDesign: UIButton!
    @IBOutlet weak var buttonComment: UIButton!
    @IBOutlet weak var collectionViewMasters: UICollectionView!
    @IBOutlet weak var collectionViewDesign: UICollectionView!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheet.setupactionSheet()
        setupCollectionView()
        imageLogo.imageCornerRadiusPlusBorder()
        masters = realm.objects(Master.self).sorted(byKeyPath: "name")
        
        
    }
    
    
    //MARK: Actions
    @IBAction func openInstagram(_ sender: Any) {
        let path = "https://www.instagram.com/flamingocentr/?igshid=1rl459j50l05s" // 1
        let url = URL(string: path)! // 3
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil) // 4
    }
    
    
    @IBAction func openWhatsApp(_ sender: Any) {
        present(actionSheet, animated: true)
    }
    
    @IBAction func openBrower(_ sender: Any) {
        let path = "https://vk.com/id22175894"
        let url = URL(string: path)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil) // 4
        
    }
    
    
    private func setupCollectionView(){
        
        //collectionViewMasters
        collectionViewMasters.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        self.collectionViewMasters?.collectionViewLayout = layout
        
        //collectionViewDesign
        //collectionViewDesign.backgroundColor = .clear
        //self.collectionViewDesign?.collectionViewLayout = layout
    }
    
    
    @IBAction func actionPresentComments(_ sender: Any) {
        performSegue(withIdentifier: "actionPresentComments", sender: nil)
    }
    
    
    @IBAction func actionNewComment(_ sender: Any) {
                guard realm.objects(Person.self).count > 0 else { //условие на существующий аккаунт
                    getAlert("", "Чтобы оставлять отзывы вам необходимо зарегистрироваться")
                    return
                }
                performSegue(withIdentifier: "presentNewComment", sender: nil)
    }
    
    private func getAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}

extension HomeVC{
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier else {return}
        if identifire == "presentMaster"{
            if let indexPath = collectionViewMasters.indexPathsForSelectedItems?.first{
                let destinationVC = segue.destination as! AddNewMasterVC
                destinationVC.master = masters[indexPath.row]
                destinationVC.viewFlg = true
            }
        }
        if identifire == "presentText"{
            print(1)
            let presentTextVC = segue.destination as! PresentTextVC
            print(2)
            
            presentTextVC.textData = self.labelDescription.text ?? ""
            
        }
    }
     
    @IBAction func unwindToHomeVC(_ unwindSegue: UIStoryboardSegue) {
        print("Registratiob")
        //let sourceViewController = unwindSegue.source as! RegistrationVC
        // Use data from the view controller which initiated the unwind segue
    }
    
}

//MARK: Collection View
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return masters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! MasterCVC
        item.name.text = masters[indexPath.row].name
        item.profil.text = masters[indexPath.row].profil
        if let imageData = masters[indexPath.row].image{
            if let image = UIImage(data: imageData){
                item.image.image = image
                item.image.imageCornerRadiusPlusBorder()
            }
        }
        item.name.textColor = .clear
        item.profil.textColor = .clear
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let widthItem = collectionView.frame.size.width*0.4
        let heightItem = collectionView.frame.size.height - 2
        return CGSize(width: heightItem, height: heightItem)
        
    }
    
}
