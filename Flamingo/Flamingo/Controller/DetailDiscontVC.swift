//
//  DetailDiscontVC.swift
//  Flamingo
//
//  Created by mac on 25/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class DetailDiscontVC: UIViewController {
    
    //private var scrollView = UIScrollView()
    private var disconts: Results<Discount>!
    var discont: Discount!
    
    @IBOutlet weak var imageDiscont: UIImageView!{
        didSet{
            imageDiscont.contentMode = .scaleToFill
            imageDiscont.layer.cornerRadius = 40
        }
    }
    @IBOutlet weak var discriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(data: discont.image!){
            imageDiscont.image = image
            discriptionLabel.text = discont.descriptionDiscount
        }else{
            imageDiscont.image = UIImage(named: "launchScr")
            discriptionLabel.text = discont.descriptionDiscount
        }
        
    }
    
   
    
    
}
