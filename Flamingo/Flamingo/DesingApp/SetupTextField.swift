//
//  SetupTextField.swift
//  Flamingo
//
//  Created by mac on 09/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
    }
    
    private func setupTextField(){
        switch self.tag {
        case 1:
            self.autocapitalizationType = .sentences
            self.backgroundColor = ColorApp.black
            self.textColor = ColorApp.white
            self.font = Font.fontRegular
            
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            
            self.layer.cornerRadius = 10
            
        case 2:
            self.autocapitalizationType = .words
            self.inputAccessoryView = addDoneButtonOnKeyboard()
            self.textColor = ColorApp.white
            self.font = Font.fontRegular
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            self.layer.cornerRadius = 10
            
        case 3:
            self.autocapitalizationType = .words
            self.inputAccessoryView = addDoneButtonOnKeyboard()
            self.textColor = ColorApp.white
            self.font = Font.fontTitle
            self.layer.borderWidth = BorderWidth.borderWidth
            self.layer.borderColor = ColorApp.indigo.cgColor
            self.layer.cornerRadius = 10
        case 4:
            self.autocapitalizationType = .words
            self.inputAccessoryView = addDoneButtonOnKeyboard()
            self.textColor = ColorApp.white
            self.font = Font.fontSubTitle
            self.borderStyle = .none
        default:
            return
        }
    }
    
}


extension UITextField{
    func fieldToFill(_ fontTF: CGFloat){
        self.autocapitalizationType = .words
        self.inputAccessoryView = addDoneButtonOnKeyboard()
        self.textColor = ColorApp.white
        self.font = Font.fontTitle
        self.font?.withSize(fontTF)
        self.backgroundColor = ColorApp.clear
        self.borderStyle = .none
        self.layer.borderWidth = BorderWidth.borderWidth
        self.layer.borderColor = ColorApp.white.cgColor
        self.layer.cornerRadius = self.frame.size.width*0.01
    }
    
    func addDoneButtonOnKeyboard() -> UIToolbar{
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        self.endEditing(true)
    }
}
