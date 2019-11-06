//
//  DetailServiceVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 31/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class DetailServiceVC: UIViewController {

    var service = Service()
    
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
