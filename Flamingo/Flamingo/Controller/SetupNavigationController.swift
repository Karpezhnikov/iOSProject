//
//  SetupNavigationBar.swift
//  Flamingo
//
//  Created by mac on 13/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //SetupNavigationController.setupBackButton() // дизайн кнопки назад
        //self.navigationBar.topItem?.backBarButtonItem?.tintColor = .init(srgbRed: 52/255, green: 0/255, blue: 63/255, alpha: 1)
    }
    
//    // MARK: setupBackButton
//    static func setupBackButton(){
//        // настраиваем кнопку назад
//        
//        if let topItem = self.navigationBar.topItem{
//            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            let imgBackArrow = UIImage(named: "leftBarButton")
//
//            navigationController?.navigationBar.backIndicatorImage = imgBackArrow
//            navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
//        }
//        
//    }
    
}
