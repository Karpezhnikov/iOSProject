//
//  TasksVC.swift
//  ToDoFire
//
//  Created by Алексей Карпежников on 24/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TasksVC: UIViewController{

    var user: User! // создаем пользователя
    var ref: DatabaseReference! // для получения данных
    var tasks = Array<Task>() // для массива задач
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else {return}// если получилось получить текущего пользователя
        user = User(user: currentUser)
        // добираемся до папки с задачами
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
        
    }
    
    // перед запуском viewDidLoad получаем все записи
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            var _tasks = Array<Task>()
            for item in snapshot.children{
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers() // удаляем наблюдателя чтобы при выходе не получать ошибки
    }
    
    // стандартный ф-я редактирование записи
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // работаем с выбраной для редактирования ячейкой
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = tasks[indexPath.row] // получаем ячейку
            task.ref?.removeValue() // удаляем ячейку
        }
    }
    
    // позволяем выполнить код при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else{return}
        let task = tasks[indexPath.row]
        let isComplited = !task.complited
        
        // добавляем флаг в таблицу
        toggleComplition(cell, isComplited: isComplited)
        task.ref?.updateChildValues(["complited": isComplited])
    }
    
    // функция ставит галочку если нажать на ячейку или none
    func toggleComplition(_ cell: UITableViewCell, isComplited: Bool){
        cell.accessoryType = isComplited ? .checkmark : .none
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New tasks", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else{return}
            let task = Task(title: textField.text!, userId: (self?.user.uid)!) // что поместить
            let taskRef = self?.ref.child(task.title.lowercased()) // адрес куда поместить
            taskRef?.setValue(task.convertToDictionart())
            print(taskRef!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func singOutTapped(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut() // выходим из аккаунта
        }catch{
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil) // закрываем view
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // наблюдатель для отображения всех записей
    

    
}

// MARK: Work Table View
extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        let task = tasks[indexPath.row]
        let taskTitle = task.title
        let isComplited = task.complited
        cell.textLabel?.text = taskTitle
        
        toggleComplition(cell, isComplited: isComplited)
        
        return cell
    }
}
