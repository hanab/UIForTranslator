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
    var langSourceDelegate=UIApplication.sharedApplication().delegate! as! AppDelegate
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
        self.sourceText.layer.borderColor = UIColor.whiteColor().CGColor
        self.trargetText.layer.borderWidth = 1.0
        self.trargetText.layer.cornerRadius = 8
        self.trargetText.layer.borderColor = UIColor.whiteColor().CGColor
        self.addToolbarOnKeyboard(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
       if(langSourceDelegate.sourceLan != nil) {
          self.addBarButtonItem(langSourceDelegate.sourceLan.getFlag(), isLeftItem: true)
       }
       if(langSourceDelegate.targetLan != nil) {
          self.addBarButtonItem(langSourceDelegate.targetLan.getFlag(), isLeftItem: false)
       }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sourceText.resignFirstResponder()
        trargetText.resignFirstResponder()
    }

    
    //show lists of supported languages
    func sourceLanList() {
        self.performSegueWithIdentifier("sourceShow", sender: self)
    }
    
    func targetLanList() {
        self.performSegueWithIdentifier("targetShow", sender: self)
    }
    
    //MARK: textview delegate methods
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(textView.text.isEmpty && sourceText.text == "") {
            self.addToolbarOnKeyboard(false)
        } else {
            self.addToolbarOnKeyboard(true)
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        sourceText.backgroundColor = UIColor.lightGrayColor()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        sourceText.backgroundColor = UIColor.whiteColor()
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    //MARK:  AccessTokenDelegate methods
    
    func translationEroor(ac: AccessTokenRequester, error: String) {
        trargetText.text = error
    }
    
    func translatedText(ac: AccessTokenRequester, text: NSString) {
        print(" start translate")
        trargetText.backgroundColor = UIColor.lightGrayColor()
        trargetText.text = text as String
    }
    
    func detectedLanguage(ac: AccessTokenRequester, lan: NSString) {
        print(" start detect")
    }

    //MARK: event action methods
    func addToolbarOnKeyboard(active:Bool) {
        let toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0,view.frame.width, 50))
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        let cancle: UIBarButtonItem = UIBarButtonItem(title: "cancle", style: UIBarButtonItemStyle.Done, target: self, action: Selector("cancleButtonAction"))
        let clear: UIBarButtonItem = UIBarButtonItem(title: "clear", style: UIBarButtonItemStyle.Done, target: self, action: Selector("clearButtonAction"))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let translate: UIBarButtonItem = UIBarButtonItem(title: "translate", style: UIBarButtonItemStyle.Done, target: self, action: Selector("translateButtonAction"))
        var items:[UIBarButtonItem] = []
        if(active == true) {
            clear.enabled = true
            translate.enabled = true
            items = [cancle,clear,flexSpace,translate]
        } else {
            clear.enabled = false
            translate.enabled = false
            items = [cancle,clear,flexSpace,translate]
        }
        
        toolbar.items = items
        toolbar.barTintColor = UIColor.greenColor()
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
        access.traslateTextFromSourceToTarget(sourceText.text, sourceLan: langSourceDelegate.sourceLan.getLangCode(), TargetLan: langSourceDelegate.targetLan.getLangCode())
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let history = NSEntityDescription.insertNewObjectForEntityForName("History",inManagedObjectContext: context) as! History
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
    
    @IBAction func speak(sender: AnyObject) {
        speakText = AVSpeechUtterance(string: sourceText.text)
        speakText.rate = 0.3
        synth.speakUtterance(speakText)
    }
    
    func addBarButtonItem(image:UIImage , isLeftItem:Bool) {
         if(isLeftItem) {
            let myBtn: UIButton = UIButton()
            myBtn.setImage(image, forState: .Normal)
            myBtn.frame = CGRectMake(0, 0, 70, 70)
            myBtn.addTarget(self, action: "sourceLanList", forControlEvents: .TouchUpInside)
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: myBtn), animated: true)
         } else {
            let myBtn2: UIButton = UIButton()
            myBtn2.setImage(image, forState: .Normal)
            myBtn2.frame = CGRectMake(0, 0, 70, 70)
            myBtn2.addTarget(self, action: "targetLanList", forControlEvents: .TouchUpInside)
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: myBtn2), animated: true)
        }
    }

    @IBAction func SwapPressed(sender: AnyObject) {
        let temp = langSourceDelegate.targetLan
        langSourceDelegate.targetLan = langSourceDelegate.sourceLan
        langSourceDelegate.sourceLan = temp
        self.addBarButtonItem(langSourceDelegate.sourceLan.getFlag(), isLeftItem: true)
        self.addBarButtonItem(langSourceDelegate.targetLan.getFlag(), isLeftItem: false)
    }
}


