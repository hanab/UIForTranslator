//
//  ViewController.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 11/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class MainViewController: UIViewController, UITextViewDelegate, AccessTokenDelegate {
    
    //MARK: properties
    let font:UIFont = UIFont(name: "AbyssinicaSIL", size: 20)!
    let access = AccessTokenRequester()
    var langSourceDelegate=UIApplication.shared.delegate! as! AppDelegate
    let synth = AVSpeechSynthesizer()
    var speakText = AVSpeechUtterance(string: "")
    //var cancle:UIBarButtonItem!

    @IBOutlet var trargetText: UITextView!
    @IBOutlet var sourceText: UITextView!
    @IBOutlet var targetButton: UIBarButtonItem!
    @IBOutlet var sourceButton: UIBarButtonItem!
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        access.delegate = self
        sourceText.delegate = self
        
        self.addBarButtonItem(langSourceDelegate.sourceLan.getFlag(), isLeftItem: true)
        self.addBarButtonItem(langSourceDelegate.targetLan.getFlag(), isLeftItem: false)
        self.sourceText.layer.borderWidth = 1.0
        self.sourceText.layer.cornerRadius = 8
        self.sourceText.layer.borderColor = UIColor.white.cgColor
        self.trargetText.layer.borderWidth = 1.0
        self.trargetText.layer.cornerRadius = 8
        self.trargetText.layer.borderColor = UIColor.white.cgColor
        //self.sourceText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

       self.addToolbarOnKeyboard(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       if(langSourceDelegate.sourceLan != nil) {
          self.addBarButtonItem(langSourceDelegate.sourceLan.getFlag(), isLeftItem: true)
       }
       if(langSourceDelegate.targetLan != nil) {
          self.addBarButtonItem(langSourceDelegate.targetLan.getFlag(), isLeftItem: false)
       }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sourceText.resignFirstResponder()
        trargetText.resignFirstResponder()
    }

    
    //show lists of supported languages
    func sourceLanList() {
        self.performSegue(withIdentifier: "sourceShow", sender: self)
    }
    
    func targetLanList() {
        self.performSegue(withIdentifier: "targetShow", sender: self)
    }
    
    //MARK: textview delegate methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView.text.isEmpty && sourceText.text == "") {
            self.addToolbarOnKeyboard(false)
        } else {
            self.addToolbarOnKeyboard(true)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         self.addToolbarOnKeyboard(true)
        sourceText.backgroundColor = UIColor.lightGray
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        sourceText.backgroundColor = UIColor.white
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    //MARK:  AccessTokenDelegate methods
    
    func translationEroor(_ ac: AccessTokenRequester, error: String) {
        trargetText.text = error
    }
    
    func translatedText(_ ac: AccessTokenRequester, text: NSString) {
        print(" start translate")
        trargetText.backgroundColor = UIColor.lightGray
        trargetText.text = text as String
    }
    
    func detectedLanguage(_ ac: AccessTokenRequester, lan: NSString) {
        print(" start detect")
    }

    //MARK: event action methods
    func addToolbarOnKeyboard(_ active:Bool) {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,width: view.frame.width, height: 50))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.barStyle = UIBarStyle.blackTranslucent
        let cancle: UIBarButtonItem = UIBarButtonItem(title: "cancle", style: UIBarButtonItemStyle.done, target: self, action: #selector(MainViewController.cancleButtonAction))
        let clear: UIBarButtonItem = UIBarButtonItem(title: "clear", style: UIBarButtonItemStyle.done, target: self, action: #selector(MainViewController.clearButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let translate: UIBarButtonItem = UIBarButtonItem(title: "translate", style: UIBarButtonItemStyle.done, target: self, action: #selector(MainViewController.translateButtonAction))
        var items:[UIBarButtonItem] = []
        if(active == true) {
            clear.isEnabled = true
            translate.isEnabled = true
            items = [cancle,clear,flexSpace,translate]
        } else {
            clear.isEnabled = false
            translate.isEnabled = false
            items = [cancle,clear,flexSpace,translate]
        }
        
        toolbar.items = items
        toolbar.barTintColor = UIColor.green
        toolbar.sizeToFit()
        self.sourceText.inputAccessoryView = toolbar
    }
    
    
    func cancleButtonAction(){
        sourceText.resignFirstResponder()
    }
    
    func clearButtonAction(){
        sourceText.text = ""
    }
    
    func translateButtonAction() {
        sourceText.resignFirstResponder()
        sourceText.font = font
        print(" start translate")
        access.traslateTextFromSourceToTarget(sourceText.text as NSString, sourceLan: langSourceDelegate.sourceLan.getLangCode() as NSString, TargetLan: langSourceDelegate.targetLan.getLangCode() as NSString)
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let history = NSEntityDescription.insertNewObject(forEntityName: "History",into: context) as! History
        history.sourceLan = langSourceDelegate.sourceLan.getLangName()
        history.targetLan = langSourceDelegate.targetLan.getLangName()
        history.sourceText = sourceText.text
        history.targetText = trargetText.text
        do {
          try context.save()
        } catch let saveEroor as NSError {
          print("Saving error \(saveEroor.localizedDescription)")
        }
    }
    
    @IBAction func speak(_ sender: AnyObject) {
        speakText = AVSpeechUtterance(string: sourceText.text)
        speakText.rate = 0.3
        synth.speak(speakText)
    }
    
    func addBarButtonItem(_ image:UIImage , isLeftItem:Bool) {
         if(isLeftItem) {
            let myBtn: UIButton = UIButton()
            myBtn.setImage(image, for: UIControlState())
            myBtn.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            myBtn.addTarget(self, action: #selector(MainViewController.sourceLanList), for: .touchUpInside)
            self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: myBtn), animated: true)
         } else {
            let myBtn2: UIButton = UIButton()
            myBtn2.setImage(image, for: UIControlState())
            myBtn2.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            myBtn2.addTarget(self, action: #selector(MainViewController.targetLanList), for: .touchUpInside)
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: myBtn2), animated: true)
        }
    }

    @IBAction func SwapPressed(_ sender: AnyObject) {
        let temp = langSourceDelegate.targetLan
        langSourceDelegate.targetLan = langSourceDelegate.sourceLan
        langSourceDelegate.sourceLan = temp
        self.addBarButtonItem(langSourceDelegate.sourceLan.getFlag(), isLeftItem: true)
        self.addBarButtonItem(langSourceDelegate.targetLan.getFlag(), isLeftItem: false)
    }
    func textFieldDidChange(_ sourceText: UITextField) {
        
        if((sourceText.text?.isEmpty)! && sourceText.text == "") {
            self.addToolbarOnKeyboard(false)
        } else {
            self.addToolbarOnKeyboard(true)
        }
        
    }
}


