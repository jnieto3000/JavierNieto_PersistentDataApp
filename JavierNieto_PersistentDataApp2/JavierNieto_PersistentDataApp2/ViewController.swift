//
//  ViewController.swift
//  JavierNieto_PersistentDataApp2
//
//  Created by X on 6/21/20.
//  Copyright © 2020 X. All rights reserved.
// 1) You will be creating an app that saves a few items of data that you select on your phone.
// 2) The choice of the data will be yours, but it should be something that makes sense to store
// 3) permanently on your phone. You may also select the method that makes the most sense to you.

import UIKit
import Foundation
import CoreData


class ViewController: UIViewController {

    var dataManager: NSManagedObjectContext!
    var listArray = [NSManagedObject]() //temp to parse data
    
    @IBAction func saveRecordButton(_ sender: Any) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Room", into: dataManager)
        newEntity.setValue(enterRoomNum.text!, forKey: "roomnum")
        newEntity.setValue(enterFahrenValue.text!, forKey: "fahrenheit")
        newEntity.setValue(enterCelsiusValue.text!, forKey: "celsius")
        newEntity.setValue(enterHumidityValue.text!, forKey: "humidity")
           
        do {
               try self.dataManager.save()
               listArray.append(newEntity)
        } catch {
               print("Error saving data")
           }
        displayDataHere.text?.removeAll()
        enterRoomNum.text?.removeAll()
        enterFahrenValue.text?.removeAll()
        enterCelsiusValue.text?.removeAll()
        enterHumidityValue.text?.removeAll()
        fetchData()
    }
    
    @IBAction func deleteRecordButton(_ sender: Any) {
        let deleteRm = enterRoomNum.text!
        //let deleteFhrnt = enterFahrenValue.text!
        
        for item in listArray{
            if item.value(forKey: "roomnum") as! String == deleteRm {
                dataManager.delete(item)
            }
            do {
                try self.dataManager.save()
            } catch {
                print("Error deleting deleteItem")
            }
            displayDataHere.text?.removeAll()
            enterRoomNum.text?.removeAll()
            enterFahrenValue.text?.removeAll()
            enterCelsiusValue.text?.removeAll()
            enterHumidityValue.text?.removeAll()
            fetchData()
        }
    }

    @IBOutlet weak var enterRoomNum: UITextField!
    @IBOutlet weak var enterFahrenValue: UITextField!
    @IBOutlet weak var enterCelsiusValue: UITextField!
    @IBOutlet weak var enterHumidityValue: UITextField!
    @IBOutlet weak var displayDataHere: UILabel! //displayDataHere
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        displayDataHere.text?.removeAll()
        fetchData()
    }
    
    func fetchData() {   // Look into Room called Item or table in DB
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Room")
        do { //try to get something out of there and if you can display it in label
            let result = try dataManager.fetch(fetchRequest)
            listArray = result as! [NSManagedObject]
            for item in listArray{
                let room = item.value(forKey: "roomnum") as! String
                let cel   =  item.value(forKey: "celsius") as! String
                let fhrnt =  item.value(forKey: "fahrenheit") as! String
                let humid =  item.value(forKey: "humidity") as! String
                displayDataHere.text! += room + cel + fhrnt + humid
            }
        }catch { // if you can't display it or problem print out error. prevent program from crashing
            print("Error retrieving data")
        }
    }
}
