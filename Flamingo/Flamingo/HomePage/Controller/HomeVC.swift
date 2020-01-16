//
//  HomeVC.swift
//  Flamingo
//
//  Created by mac on 17/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var buttomMaster: UIButton!
    @IBOutlet weak var buttonDesign: UIButton!
    @IBOutlet weak var buttonComment: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttomMaster.layer.borderWidth = BorderWidth.borderWidth
        buttomMaster.layer.borderColor = ColorApp.indigo.cgColor
        buttomMaster.layer.cornerRadius = buttomMaster.frame.size.height/2
        
        buttonDesign.layer.borderWidth = BorderWidth.borderWidth
        buttonDesign.layer.borderColor = ColorApp.indigo.cgColor
        buttonDesign.layer.cornerRadius = buttonDesign.frame.size.height/2
        
        buttonComment.layer.borderWidth = BorderWidth.borderWidth
        buttonComment.layer.borderColor = ColorApp.indigo.cgColor
        buttonComment.layer.cornerRadius = buttonComment.frame.size.height/2
    }

    
}
