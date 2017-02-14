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
    
    var langSourceDelegate=UIApplication.shared.delegate! as! AppDelegate
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
    
     override func viewWillAppear(_ animated: Bool) {
        let context =  langSourceDelegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        langSourceDelegate.historyArray = (try! context.fetch(request)) as! [History]
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancle(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getLanCode(_ name:String)->LanguageCodes {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langSourceDelegate.historyArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellController
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let note = langSourceDelegate.historyArray[indexPath.row] as History!
        let lansource = self.getLanCode((note?.sourceLan)!)
        let lantar = self.getLanCode((note?.targetLan)!)
        cell.targetText.text = note?.targetText
        cell.sourceText.text = note?.sourceText
        cell.sourceImage.image = lansource.getFlag()
        cell.targetImage.image = lantar.getFlag()
        print(note?.targetText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        switch editingStyle {
            case .delete :
            let context:NSManagedObjectContext = langSourceDelegate.managedObjectContext
            context.delete(langSourceDelegate.historyArray[indexPath.row] as NSManagedObject)
            langSourceDelegate.historyArray.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch  let deletError as NSError{
                print("delete error: \(deletError.localizedDescription)")
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
                
            default :
                return
        }
    }
}
