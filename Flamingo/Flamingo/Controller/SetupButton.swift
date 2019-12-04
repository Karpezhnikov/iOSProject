//
//  BurronSetup.swift
//  Flamingo
//
//  Created by mac on 13/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupButton: UIButton {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = BorderWidth.borderWidth
        setupButtonColor(sender: self) // устанавливаем цвета на кнопку
    }
    
    private func setupButtonColor(sender: UIButton)
    {
        switch sender.tag {
        case 0:
            self.layer.cornerRadius = self.frame.size.width/2
            sender.layer.borderColor = ColorApp.greenComplete.cgColor
            sender.tintColor = ColorApp.greenComplete
        case 1: // кнопка записи
            self.layer.cornerRadius = self.frame.size.width/2
            sender.layer.borderColor = ColorApp.black.cgColor
            sender.backgroundColor = .init(red: 0/255, green: 80/255, blue: 0/255, alpha: 0.2)
        case 2: // кнопка вызова
            self.layer.cornerRadius = self.frame.size.width/2
            sender.layer.borderColor = ColorApp.white.cgColor
            sender.backgroundColor = .init(red: 0/255, green: 0/255, blue: 126/255, alpha: 0.2)
        case 3: // кпонка комментария
            self.layer.cornerRadius = self.frame.size.width/2
            sender.layer.borderColor = ColorApp.black.cgColor
            sender.backgroundColor = .init(red: 121/255, green: 121/255, blue: 121/255, alpha: 0.5)
        case 4:
            sender.layer.borderColor = ColorApp.indigo.cgColor
            sender.layer.cornerRadius = 10
        case 5:
            self.layer.cornerRadius = self.frame.size.width/2
            sender.layer.borderColor = ColorApp.white.cgColor
        default:
            return
        }
    }
    
}
