//
//  CallAlertVC.swift
//  Flamingo
//
//  Created by mac on 21/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class CallAlertVC: UIAlertController {
}


extension UIAlertController{
    func setupCallAction(){
        self.message = "Позвонить?"
        let openTEL = UIAlertAction(title: "тел:+7(701)962-40-20", style: .default) { (_) in
            if let url = URL(string: "tel://+7(701)962-40-20") {
                UIApplication.shared.open(url)
            }
        }
        let openTEL2 = UIAlertAction(title: "тел:+7(700)931-65-29", style: .default) { (_) in
            if let url = URL(string: "tel://+7(700)931-65-29") {
                UIApplication.shared.open(url)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        self.addAction(openTEL)
        self.addAction(openTEL2)
        self.addAction(cancel)
    }
    
    func setupactionSheet(){
        self.message = "Перейти WhatsApp?"
        let openWA = UIAlertAction(title: "тел:+7(701)962-40-20", style: .default) { (_) in
            UIApplication.shared.open(URL(string:"https://api.whatsapp.com/send?phone=+77019624020")!)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        self.addAction(openWA)
        self.addAction(cancel)
    }
}
