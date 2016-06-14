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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate {
    
     //MARK: properties
     var settingsArray: [String] = ["Feedback", "About"]
     @IBOutlet var clearButton: UIButton!
     @IBOutlet var tableView: UITableView!
    
    //MARK: Methods
    
    // clear the translation history from coredata
    @IBAction func clearHistoryPressed(sender: AnyObject) {
           let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
           let managedContext = appDelegate.managedObjectContext
           let fetchRequest = NSFetchRequest(entityName: "History")
           fetchRequest.returnsObjectsAsFaults = false
        
           do {
              let results = try managedContext.executeFetchRequest(fetchRequest)
               for managedObject in results {
                  let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                  managedContext.deleteObject(managedObjectData)
               }
            } catch let error as NSError {
                  print("Detele all data in : \(error) \(error.userInfo)")
            }
    }
    
    @IBAction func cancle(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
            self.presentViewController(mc, animated:true, completion:nil)
         } else if(indexPath.row == 1) {
             self.performSegueWithIdentifier("showabout", sender: self)
         }
        
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = settingsArray[indexPath.row]
        return cell
    }
    
    //MARK: MFMailComposeViewControllerDelegate methods
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if(result == MFMailComposeResultCancelled){
            print("Mail cancelled")
        } else if(result == MFMailComposeResultSaved) {
            print("Mail saved")
        } else if( result == MFMailComposeResultSent){
            print("Mail sent")
        } else if( result==MFMailComposeResultFailed){
            print("Mail sent failure: \(error!.localizedDescription)")
        } else {
          print("noting")
        }
        
       self.dismissViewControllerAnimated(true, completion: nil)
    }
}

