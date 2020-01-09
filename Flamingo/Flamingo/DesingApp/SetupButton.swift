//
//  SetupButton.swift
//  Flamingo
//
//  Created by mac on 09/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupButton: UIButton {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.layer.borderWidth = BorderWidth.borderWidth
        setupButtonColor() // устанавливаем цвета на кнопку
        
    }
    
    private func setupButtonColor()
    {
        switch self.tag {
        case 0:
            self.layer.cornerRadius = self.frame.size.width/2
            self.layer.borderColor = ColorApp.greenComplete.cgColor
            self.tintColor = ColorApp.greenComplete
        case 1: // кнопка записи
            self.layer.cornerRadius = self.frame.size.width/2
            self.layer.borderColor = ColorApp.black.cgColor
            //self.backgroundColor = .init(red: 0/255, green: 80/255, blue: 0/255, alpha: 0.2)
        case 2: // кнопка вызова
            self.layer.cornerRadius = self.frame.size.width/2
            self.layer.borderColor = ColorApp.white.cgColor
            //self.backgroundColor = .init(red: 0/255, green: 0/255, blue: 126/255, alpha: 0.2)
        case 3: // кпонка комментария
            self.layer.cornerRadius = self.frame.size.width/2
            self.layer.borderColor = ColorApp.black.cgColor
            //self.backgroundColor = .init(red: 121/255, green: 121/255, blue: 121/255, alpha: 0.5)
        case 4:
            self.layer.borderColor = ColorApp.indigo.cgColor
            self.layer.cornerRadius = 10
        case 5:
            self.layer.cornerRadius = self.frame.size.width/2
            self.layer.borderColor = ColorApp.white.cgColor
        default:
            return
        }
    }
    
}
