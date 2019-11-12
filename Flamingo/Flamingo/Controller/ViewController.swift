//
//  ViewController.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let segueNext = "nextVC"
    var modelController = ModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.layer.cornerRadius = 20
//        self.tabBarController?.tabBar.layer.borderWidth = 0.5
//        self.tabBarController?.tabBar.layer.borderColor = .init(srgbRed: 100/255, green: 56/255, blue: 0/255, alpha: 1)
        
    }
    
    
    // MARK: Action for man part of Body
    @IBAction func hairManAction(_ sender: Any) {
        modelController.maleMan = "unisex"
        modelController.partOfBody = "Волосы"
        performSegue(withIdentifier: "nextVC", sender: nil)
    }
    
    @IBAction func headManAction(_ sender: UIButton) {
        modelController.maleMan = "unisex"
        modelController.partOfBody = "Голова"
        performSegue(withIdentifier: "nextVC", sender: nil)
    }
    
    @IBAction func bodyManAction(_ sender: UIButton) {
        modelController.maleMan = "unisex"
        modelController.partOfBody = "Тело"
        performSegue(withIdentifier: "nextVC", sender: nil)
    }
    
    @IBAction func handManAction(_ sender: UIButton) {
        modelController.maleMan = "unisex"
        modelController.partOfBody = "Руки"
        performSegue(withIdentifier: "nextVC", sender: nil)
    }
    
    @IBAction func legManAction(_ sender: UIButton) {
        modelController.maleMan = "unisex"
        modelController.partOfBody = "Ноги"
        performSegue(withIdentifier: "nextVC", sender: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let samplaPlaceVC = segue.destination as? SamplePriceListVC
            else {return}
        guard !modelController.partOfBody.isEmpty else {return}
        if identifire == segueNext{
            samplaPlaceVC.modelController = modelController
        }
        // ToDo: дописать метод после определения всех нужных частей тела
        
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

