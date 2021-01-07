//
//  SettingsViewController.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 07/01/21.
//  Copyright © 2021 Vinod Reddy Sure. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetAction(_ sender: Any) {

         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         
         let managedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMarkedCities")
        
            do
         {
             let result = try managedContext.fetch(fetchRequest)
             for managedObject in result as! [NSManagedObject]
             {
                let managedObjectData:NSManagedObject = managedObject
                managedContext.delete(managedObjectData)
             }
            
            do{
                try managedContext.save()
                
                
            }
            catch
            {
                print(error)
            }
            
            let alertController = UIAlertController(title: "Alert", message: "Detele all BookMarkedCities", preferredStyle: .alert)
               
               let saveAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in

               })
               alertController.addAction(saveAction)

               self.present(alertController, animated: true, completion: nil)
             }
             catch let error as NSError {
             print("Detele all data in BookMarkedCities error : \(error) \(error.userInfo)")
         }


    }

}
