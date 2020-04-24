//
//  PresentTrueAndActionVC.swift
//  GamesTeam
//
//  Created by kam_team on 11.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit



class PresentTrueAndActionVC: UIViewController {

    @IBOutlet weak var viewPresent: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    
    var questionOrAction:QuestionsAndActions? = nil
    var presentProcessGame = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupElement()
        // Do any additional setup after loading the view.
    }
    
    private func setupElement(){
        self.viewPresent.backgroundColor = .clear
        self.labelText.textColor = ColorApp.blackApp
        self.labelText.font = UIFont(name: FontApp.markerWide, size: 25)
        self.labelText.text = questionOrAction?.bodyQQ
        self.titleLable.font = UIFont(name: FontApp.markerWide, size: 40)
        
        self.buttonClose.layer.cornerRadius = self.buttonClose.frame.size.height/2
        self.buttonClose.titleLabel?.font = UIFont(name: FontApp.markerWide, size: 25)
        self.buttonClose.setTitle("Готово", for: .normal)
        
        switch questionOrAction!.qoa {
        case .action:
            self.titleLable.text = "Действие"
            self.titleLable.textColor = ColorApp.purple
            self.view.backgroundColor = ColorApp.purple?.withAlphaComponent(0.3) ?? ColorApp.blackApp.withAlphaComponent(0.3)
        case .question:
            self.titleLable.text = "Правда"
            self.titleLable.textColor = ColorApp.orange
            self.view.backgroundColor = ColorApp.orange?.withAlphaComponent(0.3) ?? ColorApp.blackApp.withAlphaComponent(0.3)
        default:
            self.titleLable.text = ""
        }
    }
    

    //MARK: Actions
    @IBAction func closeCV(_ sender: UIButton){
        if !presentProcessGame{
            NotificationCenter.default.post(name: .init(rawValue: "nextPlayerMoveTrueAndActionVC"), object: nil)
        }
        self.dismiss(animated: true, completion: nil)
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
