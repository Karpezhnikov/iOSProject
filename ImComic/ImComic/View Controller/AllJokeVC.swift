//
//  AllJokeVC.swift
//  ImComic
//
//  Created by Алексей Карпежников on 23/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class AllJokeVC: UIViewController {
    
    
    let jokeArray = ["Опыт древних Афин убедительно показывает: чтобы одна часть населения стала философами, другая была рабами.",
                     "Человечество могло считать себя свободным, пока телефоны сидели на привязи.",
                     "- Всё в ваших руках! И это, по-вашему, всё?!",
                     "У нас маленькое, но настоящее землетрясение. А кошка спит. Она что, бракованная?",
                     "О чём нам может рассказать классный журнал: если двойки по горизонтали, то ученик дурак, а если по вертикали - учитель.",
                     "Законы физики - это единственные законы, которые соблюдаются в мире."]
    let nickNameArray = ["Aleksey686", "Ivan333","Oleg456","Super Puska","Cat222","Kirril345"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
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

// MARK: Worked these Table View
extension AllJokeVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jokeArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTVCell
        
        cell.textJoke.text = jokeArray[indexPath.row]
        cell.nicNameLabel.text = nickNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // для того, чтобы ячейка не выделялась
    }
    
}
