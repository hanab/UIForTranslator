//
//  SettingsViewController.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 12/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
     //MARK: properties
     var settingsArray: [String] = ["Feedback", "About"]
     @IBOutlet var clearButton: UIButton!
     @IBOutlet var tableView: UITableView!
    
    //MARK: Methods
    
    // clear the translation history from coredata
    @IBAction func clearHistoryPressed(_ sender: AnyObject) {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let managedContext = appDelegate.managedObjectContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
           fetchRequest.returnsObjectsAsFaults = false
        let alertController = UIAlertController(title: "Clear History", message: "Do you want to clear translation history?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            do {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Detele all data in : \(error) \(error.userInfo)")
            }
            
            

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancle(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        clearButton.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK : tableView delegate and datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if(indexPath.row == 0) {
            // Email Subject
            let  emailTitle:String = "FeedBack";
            // Email Content
            let messageBody:String = "Write your message here!"
            // To address
            let toRecipents: Array = ["hb16826@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle )
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            // Present mail view controller on screen
            self.present(mc, animated:true, completion:nil)
         } else if(indexPath.row == 1) {
             self.performSegue(withIdentifier: "showabout", sender: self)
         }
        
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.text = settingsArray[indexPath.row]
        return cell
    }
    
    //MARK: MFMailComposeViewControllerDelegate methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        if(result == MFMailComposeResultCancelled){
//            print("Mail cancelled")
//        } else if(result == MFMailComposeResultSaved) {
//            print("Mail saved")
//        } else if( result == MFMailComposeResultSent){
//            print("Mail sent")
//        } else if( result == MFMailComposeResultFailed){
//            print("Mail sent failure: \(error!.localizedDescription)")
//        } else {
//          print("noting")
//        }
        print()
        
       self.dismiss(animated: true, completion: nil)
    }
}

