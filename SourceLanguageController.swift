//
//  SourceLanguageController.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 11/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import UIKit

class SourceLangugeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    var langSourceDelegate=UIApplication.sharedApplication().delegate! as! AppDelegate
    @IBOutlet var tableView: UITableView!
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .SingleLine
        self.tableView.separatorColor = UIColor.greenColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @IBAction func cancle(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: tableViewDelegateAndDatasource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langSourceDelegate.languageArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        langSourceDelegate.sourceLan = LanguageCodes(name: langSourceDelegate.languageArray[indexPath.row].getLangName(), langCode: langSourceDelegate.languageArray[indexPath.row].getLangCode(), flag: langSourceDelegate.languageArray[indexPath.row].getFlag())
        print(langSourceDelegate.sourceLan.getLangCode())
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = langSourceDelegate.languageArray[indexPath.row].getLangName()
        cell.imageView?.image = langSourceDelegate.languageArray[indexPath.row].getFlag()
        return cell
    }

}

