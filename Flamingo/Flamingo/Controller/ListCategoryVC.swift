//
//  ListCategoryVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class ListCategoryVC: UIViewController {

    var titleView = "" // название выбранной категории 
    
    let arrayCategori = [["ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ":"МАССАЖ ЛИЦА"],
                         ["ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ":"ЧИСТКА ЛИЦА"],
                         ["УЛЬТРАЗВУКОВАЯ":"ЧИСТКА ЛИЦА"],
                         ["ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ":"УХОД ДЛЯ ЛИЦА"],
                         ["ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ":"ПИЛИНГ ЛИЦА"],
                         ["ЭСТЕТИЧЕСКАЯ КОСМЕТОЛОГИЯ":"ЭЛЕКТРОКОАГУЛЯЦИЯ ПАПИЛЛОМ И РОДИНОК"],
                         ["ИНЪЕКЦИОННАЯ КОСМЕТОЛОГИЯ":"КОНТУРНАЯ ПЛАСТИКА"],
                         ["АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА":"ОЗОНОТЕРАПИЯ"],
                         ["АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА":"BB GLOW TREATMENT. «ТОНАЛЬНЫЙ КРЕМ НА ГОД»"],
                         ["АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА":"ФОТОТЕРАПИЯ"],
                         ["АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА":"ЭЛЕКТРОПОРАЦИЯ. БЕЗИНЪЕКЦИОННАЯ МЕЗОТЕРАПИЯ."],
                         ["АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА":"РАДИОВОЛНОВОЙ ЛИФТИНГ"],
                         ["АППАРАТНАЯ КОСМЕТОЛОГИЯ ЛИЦА":"ВАКУУМНЫЙ МАССАЖ"]]
    var arrayCategoryValues = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newArrayValues() // получаем список услуг
        self.title = titleView // всталяем название окна
        
    }
    

    func newArrayValues(){
        let values = arrayCategori.map { [weak self] (dictionary) -> String? in
            return dictionary[self!.titleView] // получаем массив из выбраной категории
        }
        for value in values{
            if value != nil{ // проверяем на запись nil
                arrayCategoryValues.append(value!) // заполняем список услуг по данной категории
            }
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
extension ListCategoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCategoryValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrayCategoryValues[indexPath.row]
        
        return cell
    }
    
    
}
