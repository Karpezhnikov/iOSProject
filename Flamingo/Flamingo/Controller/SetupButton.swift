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
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.borderWidth = 2
        setupButtonColor(sender: self) // устанавливаем цвета на кнопку
    }
    
    private func setupButtonColor(sender: UIButton)
    {
        switch sender.tag {
        case 1: // кнопка записи
            sender.layer.borderColor = .init(srgbRed: 0/255, green: 200/255, blue: 0/255, alpha: 1)
            sender.backgroundColor = .init(red: 0/255, green: 80/255, blue: 0/255, alpha: 0.2)
        case 2: // кнопка вызова
            sender.layer.borderColor = .init(srgbRed: 0/255, green: 0/255, blue: 255/255, alpha: 1)
            sender.backgroundColor = .init(red: 0/255, green: 0/255, blue: 126/255, alpha: 0.2)
        case 3: // кпонка комментария
            sender.layer.borderColor = .init(srgbRed: 121/255, green: 121/255, blue: 121/255, alpha: 1)
            sender.backgroundColor = .init(red: 121/255, green: 121/255, blue: 121/255, alpha: 0.5)
        
        default:
            return
        }
    }
    
}
