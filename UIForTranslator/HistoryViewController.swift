//
//  HistoryViewController.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 12/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//



import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource{
    
    //MARK: Properties
    
    var langSourceDelegate=UIApplication.sharedApplication().delegate! as! AppDelegate
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
     override func viewWillAppear(animated: Bool) {
        let context =  langSourceDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "History")
        langSourceDelegate.historyArray = (try! context.executeFetchRequest(request)) as! [History]
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancle(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getLanCode(name:String)->LanguageCodes {
        var langCode:LanguageCodes!
        for i in 0...self.langSourceDelegate.languageArray.count-1 {
            if(self.langSourceDelegate.languageArray[i].getLangName() == name) {
               langCode = self.langSourceDelegate.languageArray[i]
               break
            }
        }
        return langCode
    }

    //MARK: tableViewDataSourceAndDelegate Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langSourceDelegate.historyArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCellController
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let note = langSourceDelegate.historyArray[indexPath.row] as History!
        let lansource = self.getLanCode(note.sourceLan)
        let lantar = self.getLanCode(note.targetLan)
        cell.targetText.text = note.targetText
        cell.sourceText.text = note.sourceText
        cell.sourceImage.image = lansource.getFlag()
        cell.targetImage.image = lantar.getFlag()
        print(note.targetText)
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        switch editingStyle {
            case .Delete :
            let context:NSManagedObjectContext = langSourceDelegate.managedObjectContext
            context.deleteObject(langSourceDelegate.historyArray[indexPath.row] as NSManagedObject)
            langSourceDelegate.historyArray.removeAtIndex(indexPath.row)
            
            do {
                try context.save()
            } catch  let deletError as NSError{
                print("delete error: \(deletError.localizedDescription)")
            }
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            default :
                return
        }
    }
}
