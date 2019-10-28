//
//  ViewController.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //assignbackground()
    }
    @IBAction func headAction(_ sender: UIButton) {
        
    }
    
    @IBAction func bodyAction(_ sender: UIButton) {
    }
    
    @IBAction func handAction(_ sender: UIButton) {
    }
    
    @IBAction func legAction(_ sender: UIButton) {
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDeteil"{ // определяем нужный сигвей
//            guard let indexPath = tableView.indexPathForSelectedRow else {return} // определяем индекс строки
//            // создаем экземпляр класса по нужному индексу
//            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
//            let newPlaceVC = segue.destination as! NewPlaceViewController // создаем связть с другим вью
//            newPlaceVC.currentPlace = place
//        }
//    }
    
//    guard let identifire = segue.identifier, let mapVC = segue.destination as? MapViewController else {return}
//
//    mapVC.incomeSegueIdentifier = identifire
//    mapVC.mapViewControllerDelegate = self
//
//    if identifire == "showPlace"{
//        mapVC.place.name = placeName.text!
//        mapVC.place.location = placeLocation.text
//        mapVC.place.type = placeType.text
//        mapVC.place.imageData = placeImage.image?.pngData()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("asda")
        guard let identifire = segue.identifier, let samplaPlaceVC = segue.destination as? SamplePriceListVC
            else {
                print("NONONO")
                return}
        
        if identifire == "segueHead"{
            print("segueHead")
            samplaPlaceVC.priceList.humanMale = "man"
            samplaPlaceVC.priceList.partOfBody = "head"
            samplaPlaceVC.priceList.samplePriceList = ["Стрижка Бокс", "Стрижка Полубокс", "Стрижка налосо"]
        }
        
    }
    
    func assignbackground(){
        let background = UIImage(named: "backgroundPriceList")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
}

