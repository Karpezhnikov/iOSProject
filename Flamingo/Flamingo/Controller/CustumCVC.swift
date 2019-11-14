//
//  CustumCVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 06/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustumCVC: UICollectionViewCell {
    var itemPressed = false
    
    @IBOutlet weak var nameCotegoryService: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    
   override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    
   }
}

class CustumCVCDeteil: UICollectionViewCell {
    var itemPressed = false
    
 
    @IBOutlet weak var imageMaster: UIImageView!
    @IBOutlet weak var nameMaster: UILabel!
    @IBOutlet weak var profilMaster: UILabel!
    @IBOutlet weak var timeAndPriceMaster: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageMaster.layer.cornerRadius = imageMaster.frame.size.width/2

    }
}

