//
//  CustomTVCell.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 25/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustomTVCell: UITableViewCell {

    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var timeService: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameService.lineBreakMode = .byWordWrapping
        nameService.numberOfLines = 0
        
//        layer.cornerRadius = 15
//        //layer.masksToBounds = false
//        
//        contentView.layer.borderWidth = 0.5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

//    override open var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame =  newFrame
//            frame.origin.y += 5
//            frame.origin.x += 5
//            frame.size.height -= 5
//            frame.size.width -= 2 * 5
//            super.frame = frame
//        }
//    }

}
