//
//  SetupLabel.swift
//  Flamingo
//
//  Created by mac on 18/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

/*
Разделим UILabel на теги
tag 1 - Title (Bold, 25)
tag 2 - Title (Bold, 25) + border
tag 3 - SubTitle (Bold, 20)
tag 4 - SubTitle (Bold, 20) + border
tag 5 - Regular (Regular, 15)
tag 6 - Regular (Regular, 15) + border
tag 7 - Small (Regular, 10)
tag 8 - Small (Regular, 10) + border
**/


import UIKit

class SetupLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = ColorApp.white
        setupFontLabal(sender: self)
        
        
    }

    private func setupFontLabal(sender: UILabel){
        switch sender.tag {
        case 1: //1 - Title (Bold, 25)
            sender.font = Font.fontTitle
        case 2: //2 - Title (Bold, 25) + border
            sender.font = Font.fontTitle
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            self.layer.cornerRadius = 10
            
        case 3:
            sender.font = Font.fontSubTitle
        case 4:
            sender.font = Font.fontSubTitle
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            self.layer.cornerRadius = 10
            
        case 5:
            sender.font = Font.fontRegular
        case 6:
            sender.font = Font.fontRegular
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            self.layer.cornerRadius = 10
            
        case 7:
            sender.font = Font.fontSmall
        case 8:
            sender.font = Font.fontSmall
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            self.layer.cornerRadius = 10
        default:
            sender.font = Font.fontRegular
        }
    }
    
}
