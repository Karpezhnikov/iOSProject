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
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let samplaPlaceVC = segue.destination as? SamplePriceListVC
            else {return}
        
        if identifire == "segueHead"{
            print("segueHead")
            samplaPlaceVC.arrayComsmetology.humanMale = "man"
            samplaPlaceVC.arrayComsmetology.partOfBody = "Голова"
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

