//
//  CloseGameAVC.swift
//  GamesTeam
//
//  Created by kam_team on 14.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class CloseGameAVC: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleFont = [NSAttributedString.Key.font: UIFont(name: FontApp.markerWide, size: 18.0)!]
        let titleAttrString = NSMutableAttributedString(string: "Завершить игру?", attributes: titleFont)
        self.setValue(titleAttrString, forKey: "attributedTitle")
    }
    
    func addActionsAVC(_ closeVC: UIViewController){
        let actionContinue = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
        let actionCloseGame = UIAlertAction(title: "Завершить", style: .default) { (_) in
            closeVC.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .init(rawValue: "CloseSetupGameVC"), object: nil)
        }
        self.addAction(actionContinue)
        self.addAction(actionCloseGame)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
