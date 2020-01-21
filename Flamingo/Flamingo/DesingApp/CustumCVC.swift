//
//  CustumCVC.swift
//  Flamingo
//
//  Created by mac on 09/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
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


class CustumCVCMaster: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameMaster: UILabel!
    @IBOutlet weak var profilMaster: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        imageMaster.layer.cornerRadius = imageMaster.frame.size.width/2
//
//    }
}

class CustomCVCAlbum: UICollectionViewCell{
    
    @IBOutlet weak var imageAlbum: UIImageView!
}

class DesignCVC: UICollectionViewCell{
    @IBOutlet weak var image: UIImageView!
}

class MasterCVC: UICollectionViewCell{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profil: SetupLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //image.imageCornerRadiusPlusBorder()

        
    }
}
