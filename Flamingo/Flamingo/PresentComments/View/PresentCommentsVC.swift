//
//  PresentCommentsVC.swift
//  Flamingo
//
//  Created by mac on 04.02.2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase

class PresentCommentsVC: UIViewController {

    var arrayComments = Array<Comment>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        activeIndicator.startAnimating()
        setupButton()
        getAllComments()
    }
    
    private func setupButton(){
        let button = UIButton.init(type: .custom)
        button.setTitle(" Назад  ", for: .normal)
        button.setTitleColor(ColorApp.redExit, for: .normal)
        button.tintColor = ColorApp.redExit
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        button.addTarget(self, action: #selector(self.handleButton), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func handleButton( sender : UIButton ) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}

//MARK: Table view
extension PresentCommentsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTVCell
        cell.commentBody.text = arrayComments[indexPath.row].commentBody
        cell.namePerson.text = arrayComments[indexPath.row].namePerson
        cell.dateComment.text = WorkTimeAndDate.dateFromConvert(arrayComments[indexPath.row].date, mask: "EEEE, MMMM d")
        
        switch arrayComments[indexPath.row].rating {
        case 1:
            cell.oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.twoStar.setImage(UIImage(systemName: "star"), for: .normal)
            cell.threeStar.setImage(UIImage(systemName: "star"), for: .normal)
            cell.forStar.setImage(UIImage(systemName: "star"), for: .normal)
            cell.fiveStar.setImage(UIImage(systemName: "star"), for: .normal)
        case 2:
            cell.oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.twoStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.threeStar.setImage(UIImage(systemName: "star"), for: .normal)
            cell.forStar.setImage(UIImage(systemName: "star"), for: .normal)
            cell.fiveStar.setImage(UIImage(systemName: "star"), for: .normal)
        case 3:
            cell.oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.twoStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.threeStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.forStar.setImage(UIImage(systemName: "star"), for: .normal)
            cell.fiveStar.setImage(UIImage(systemName: "star"), for: .normal)
        case 4:
            cell.oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.twoStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.threeStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.forStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.fiveStar.setImage(UIImage(systemName: "star"), for: .normal)
        case 5:
            cell.oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.twoStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.threeStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.forStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.fiveStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
        default:
            cell.oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.twoStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.threeStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.forStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.fiveStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        return cell
    }
    
}

//MARK: Get All Comments
extension PresentCommentsVC{
    func getAllComments(){
        let firebaseBD = FirebaseManager.firebaseBD
        let collectionComment = firebaseBD.collection("commentFlamingo")
        collectionComment.getDocuments{[weak self](querySnapshot, err) in // get disconts
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }else{
                guard querySnapshot != nil else {
                    return
                }
                for document in querySnapshot!.documents{
                    let data = document.data()
                    guard let timeStump = (data["date"] as? Timestamp) else {return}
                    let comment = Comment()
                    comment.namePerson = data["namePerson"] as? String ?? ""
                    comment.rating = data["rating"] as? Int ?? 5
                    comment.date = timeStump.dateValue()
                    comment.commentBody = data["commentBody"] as? String ?? ""
                    self!.arrayComments.append(comment)
                }
                self!.tableView.reloadData()
                self!.tableView.isHidden = false
                self!.activeIndicator.stopAnimating()
                self!.activeIndicator.isHidden = true
            }
        }
    }
}
