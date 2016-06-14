//
//  TargetLanguageController.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 11/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import UIKit

class TargetLanguageController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: Properties
    
    var langSourceDelegate=UIApplication.sharedApplication().delegate! as! AppDelegate
    @IBOutlet var tableView: UITableView!
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: tableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langSourceDelegate.languageArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        langSourceDelegate.targetLan = LanguageCodes(name: langSourceDelegate.languageArray[indexPath.row].getLangName(), langCode: langSourceDelegate.languageArray[indexPath.row].getLangCode(), flag: langSourceDelegate.languageArray[indexPath.row].getFlag())
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = langSourceDelegate.languageArray[indexPath.row].getLangName()
        cell.imageView?.image = langSourceDelegate.languageArray[indexPath.row].getFlag()
        return cell
    }
    
    @IBAction func cancle(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

