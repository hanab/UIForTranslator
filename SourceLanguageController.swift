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
    
    var langSourceDelegate=UIApplication.shared.delegate! as! AppDelegate
    @IBOutlet var tableView: UITableView!
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor.green
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @IBAction func cancle(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: tableViewDelegateAndDatasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langSourceDelegate.languageArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        langSourceDelegate.sourceLan = LanguageCodes(name: langSourceDelegate.languageArray[indexPath.row].getLangName(), langCode: langSourceDelegate.languageArray[indexPath.row].getLangCode(), flag: langSourceDelegate.languageArray[indexPath.row].getFlag())
        print(langSourceDelegate.sourceLan.getLangCode())
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = langSourceDelegate.languageArray[indexPath.row].getLangName()
        cell.imageView?.image = langSourceDelegate.languageArray[indexPath.row].getFlag()
        return cell
    }

}

