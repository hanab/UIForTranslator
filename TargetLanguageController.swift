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
    
    var langSourceDelegate=UIApplication.shared.delegate! as! AppDelegate
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langSourceDelegate.languageArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        langSourceDelegate.targetLan = LanguageCodes(name: langSourceDelegate.languageArray[indexPath.row].getLangName(), langCode: langSourceDelegate.languageArray[indexPath.row].getLangCode(), flag: langSourceDelegate.languageArray[indexPath.row].getFlag())
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = langSourceDelegate.languageArray[indexPath.row].getLangName()
        cell.imageView?.image = langSourceDelegate.languageArray[indexPath.row].getFlag()
        return cell
    }
    
    @IBAction func cancle(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}

