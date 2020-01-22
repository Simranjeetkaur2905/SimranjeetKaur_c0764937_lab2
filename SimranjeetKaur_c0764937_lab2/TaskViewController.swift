//
//  TaskViewController.swift
//  SimranjeetKaur_c0764937_lab2
//
//  Created by Simran Chakkal on 2020-01-21.
//  Copyright © 2020 simran. All rights reserved.
//

import UIKit
import CoreData
class TaskViewController: UIViewController {

    var tasks:[Taskarray]?
    var tableTask:TaskDeatilTableViewController?
    
    @IBOutlet var taskname: UITextField!
    @IBOutlet var numberdays: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveCoreData()
              NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    func getFilePath() -> String{
           let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
           if documentPath.count > 0 {
               let documentDirectory = documentPath[0]
               let filePath = documentDirectory.appending("/data.txt")
               return filePath
           }
           return ""
       }
    @objc func saveCoreData() {
             // call clear core data
           
             clearCoreData()

             // create an instance of app delegate
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             // second step is context
             let managedContext = appDelegate.persistentContainer.viewContext

             for task in tasks! {
                 let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "TaskArray", into: managedContext)
                 taskEntity.setValue(task.title, forKey: "title")
               taskEntity.setValue(task.days, forKey: "days")
               taskEntity.setValue(task.date, forKey: "date")

                 // save context
                 do {
                     try managedContext.save()
                 } catch {
                     print(error)
                 }
             }
           loadCoreData()
         }
       func loadCoreData() {
              tasks = [Taskarray]()
              // create an instance of app delegate
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              // second step is context
              let managedContext = appDelegate.persistentContainer.viewContext

              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskArray")

              do {
                  let results = try managedContext.fetch(fetchRequest)
                  if results is [NSManagedObject] {
                      for result in results as! [NSManagedObject] {
                          let task = result.value(forKey: "title") as! String
                          let taskdays = result.value(forKey: "days") as! Int
                       let date = result.value(forKey: "date") as! String
                         tasks?.append(Taskarray(title:task,days: Int(taskdays) ?? 0,date: date))
                      }
                  }

              } catch {
                  print(error)
              }

          }
    func clearCoreData() {
              // create an instance of app delegate
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              // second step is context
              let managedContext = appDelegate.persistentContainer.viewContext
              // create a fetch request
              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskArray")

              fetchRequest.returnsObjectsAsFaults = false

              do {
                  let results = try managedContext.fetch(fetchRequest)
                  for managedObjects in results {
                      if let managedObjectData = managedObjects as? NSManagedObject {
                          managedContext.delete(managedObjectData)
                      }
                  }
              } catch {
                  print(error)
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
    
    @IBAction func tasksave(_ sender: UIButton) {
        let name = taskname.text ?? ""
        let day = Int(numberdays.text ?? "" ) ?? 0
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "YYYY-mm-dd HH:mm:ss"
        let datestr = format.string(from: date)
        
        let task = Taskarray(title: name, days: day, date: datestr)
        tasks?.append(task)
        taskname.text = ""
        numberdays.text = ""
        taskname.resignFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
           
           tableTask?.updateTask(taskitem: tasks!)
       }
    
}
