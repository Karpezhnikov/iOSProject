//
//  SetupTextField.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.font = Font.fontRegular
        self.textColor = ColorApp.white
        
        self.layer.borderWidth = BorderWidth.borderWidth
        self.layer.borderColor = ColorApp.indigo.cgColor
        
        setupTextField()
    }
    
    private func setupTextField(){
        switch self.tag {
        case 1: // кнопка записи
            self.backgroundColor = ColorApp.lagthGreyColor
            self.textColor = ColorApp.white
            self.font = Font.fontRegular
            
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            
        default:
            return
        }
    }

}



