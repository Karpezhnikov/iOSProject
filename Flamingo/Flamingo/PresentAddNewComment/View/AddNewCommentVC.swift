//
//  AddNewCommentVC.swift
//  Flamingo
//
//  Created by mac on 05.02.2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class AddNewCommentVC: UIViewController {

    let comment = Comment()
    var rating = 0
    
    @IBOutlet weak var buttonStarOne: UIButton!
    @IBOutlet weak var buttonStarTwo: UIButton!
    @IBOutlet weak var buttonStarThree: UIButton!
    @IBOutlet weak var buttonStarFor: UIButton!
    @IBOutlet weak var buttonStarFive: UIButton!
    @IBOutlet weak var textVeiwComment: UITextView!
    @IBOutlet weak var buttonSendComment: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    private func setupElements(){
        textVeiwComment.backgroundColor = ColorApp.black
        textVeiwComment.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        textVeiwComment.textColor = ColorApp.white
        
        //let buttonSendComment = UIButton.init(type: .custom)
        buttonSendComment.setTitle(" Отправить", for: .normal)
        buttonSendComment.setTitleColor(ColorApp.greenComplete, for: .normal)
        buttonSendComment.setImage(UIImage(systemName: "paperplane"), for: .normal)
        buttonSendComment.tintColor = ColorApp.greenComplete
        buttonSendComment.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        buttonSendComment.addTarget(self, action: #selector(self.actionSendComment), for: .touchUpInside)
        
        let buttonExit = UIButton.init(type: .custom)
        buttonExit.setTitle(" Отмена  ", for: .normal)
        buttonExit.setTitleColor(ColorApp.redExit, for: .normal)
        buttonExit.setImage(UIImage(systemName: "xmark"), for: .normal)
        buttonExit.tintColor = ColorApp.redExit
        buttonExit.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        buttonExit.addTarget(self, action: #selector(self.actionExit), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: buttonExit)]
        
        
    }
    
    //MARK: Actions
    @objc func actionSendComment( sender : UIButton ) {
        guard rating > 0 else {
            getAlert("", "Поставьте рейтинг")
            return
        }
        guard textVeiwComment.text != "" else {
            getAlert("", "Заполните поле комментария")
            return
        }
        commentCollect() // собираем отзыв
        FirebaseManager.saveCommentToFirebase(comment)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func commentCollect(){
        let persons = realm.objects(Person.self)
        guard let person = persons.first else {return}
        comment.namePerson = person.name
        comment.rating = rating
        comment.date = Date()
        comment.commentBody = textVeiwComment.text
    }
    
    private func getAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func actionExit( sender : UIButton ) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionReting(_ sender: UIButton) {
        
        switch sender.tag{
        case 1:
            buttonStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarTwo.setImage(UIImage(systemName: "star"), for: .normal)
            buttonStarThree.setImage(UIImage(systemName: "star"), for: .normal)
            buttonStarFor.setImage(UIImage(systemName: "star"), for: .normal)
            buttonStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            rating = 1
        case 2:
            buttonStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarThree.setImage(UIImage(systemName: "star"), for: .normal)
            buttonStarFor.setImage(UIImage(systemName: "star"), for: .normal)
            buttonStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            rating = 2
        case 3:
            buttonStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarFor.setImage(UIImage(systemName: "star"), for: .normal)
            buttonStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            rating = 3
        case 4:
            buttonStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarFor.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            rating = 4
        case 5:
            buttonStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarFor.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonStarFive.setImage(UIImage(systemName: "star.fill"), for: .normal)
            rating = 5
        default:
            return
        }
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
