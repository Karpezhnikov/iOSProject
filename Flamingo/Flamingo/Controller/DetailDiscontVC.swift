//
//  DetailDiscontVC.swift
//  Flamingo
//
//  Created by mac on 25/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import RealmSwift

class DetailDiscontVC: UIViewController {
    //userInteractive
    //private var scrollView = UIScrollView()
    let animate = AnimateUI()
    private var disconts: Results<Discont>!
    var discont: Discont!
    
    @IBOutlet weak var imageDiscont: UIImageView!
    
    @IBOutlet weak var nameDiscont: SetupLabel!
    @IBOutlet weak var discriptionDiscont: SetupLabel!
    @IBOutlet weak var dateValid: SetupLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        cleatViewController()
        animateRun()
        
    }
    
    @IBAction func callAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Контанты", message: "тел: +7(915)065-83-16\nWhatsApp: +7(915)065-83-16", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true)
        
    }
    
    //MARK: Setup elements
    private func setupViewElements(){
        nameDiscont.text = discont.name
        dateValid.text = "C \(discont.dateStart) по \(discont.dateEnd)"
        
        imageDiscont.contentMode = .scaleAspectFill
        //imageDiscont.layer.cornerRadius = 40
        if let image = UIImage(data: discont.image!){
            imageDiscont.image = image
            discriptionDiscont.text = discont.descriptionDiscont
        }else{
            imageDiscont.image = UIImage(named: "launchScr")
            discriptionDiscont.text = discont.descriptionDiscont
        }
    }
}

// MARK: Animate
extension DetailDiscontVC{
    
    
    private func cleatViewController(){
        imageDiscont.alpha = 0
        nameDiscont.alpha = 0
        discriptionDiscont.alpha = 0
        dateValid.alpha = 0
        self.view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //animate.animateAlpha(element: nameDiscont, toAlpha: 0.5, animateRunTime: 5.5)//шаг 2 - исчезает название
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.alpha = 1
        })
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.imageDiscont.alpha = 1
        })
        UIView.animate(withDuration: 1, delay: 0.3, options: .curveEaseOut, animations: {
            self.nameDiscont.alpha = 1
        })
        UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseOut, animations: {
            self.discriptionDiscont.alpha = 1
        })
        UIView.animate(withDuration: 1, delay: 0.9, options: .curveEaseOut, animations: {
            self.dateValid.alpha = 1
        })
    }
    
    private func animateRun(){
    }
}
