//
//  KeyboardViewController.swift
//  AmharicKeyboard
//
//  Created by Hana  Demas on 25/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UIGestureRecognizerDelegate {
    
    //  MARK: Properties
    
    // extended views which appear when longpressing a key
    var exrow1 = UIView()
    var exrow2 = UIView()
    
    // keyboard key rows
    var row1:UIView!
    var row2:UIView!
    var row3:UIView!
    var row4:UIView!
    var rows:UIView!
    
    //font file for Amharic language since iOS doesnt support it
    let font:UIFont = UIFont(name: "AbyssinicaSIL", size: 20)!
    
    //dictionary of the amharic letters as key of a letter and values the extended keys
    let letterRow : [String: [String]] = ["ሀ": ["ሀ","ሁ","ሂ","ሃ","ሄ","ህ","ሆ"], "ለ" : ["ለ","ሉ","ሊ","ላ","ሌ","ል", "ሎ","ሏ"], "ሐ" : ["ሐ","ሑ","ሒ","ሓ","ሔ","ሕ","ሕ","ሖ","ሗ"], "መ" : ["መ","ሙ","ሚ","ማ","ሜ","ም","ሞ","ሟ"], "ሠ" : ["ሠ","ሡ","ሢ","ሣ","ሤ","ሥ","ሦ","ሧ"] , "ረ" : ["ረ","ሩ","ሪ","ራ","ሬ","ር","ሮ","ሯ"], "ሰ":["ሰ","ሱ","ሲ","ሳ","ሴ","ስ","ሶ","ሷ"], "ሸ" : ["ሸ","ሹ","ሺ","ሻ","ሼ","ሽ","ሾ","ሿ"], "ቀ" : ["ቀ","ቁ","ቂ","ቃ","ቄ","ቅ","ቆ","ቋ"],"ቐ" : ["ቐ","ቑ","ቒ","ቓ","ቔ","ቕ","ቖ"], "በ" : ["በ","ቡ","ቢ","ባ","ቤ","ብ","ቦ","ቧ"], "ቨ" : ["ቨ","ቩ","ቪ","ቫ","ቬ","ቭ","ቮ","ቯ"], "ተ" : ["ተ","ቱ","ቲ","ታ","ቴ","ት","ቶ","ቷ"], "ቸ" : ["ቸ","ቹ","ቺ","ቻ","ቼ","ች","ቾ","ቿ"],"ኀ" : ["ኀ","ኁ","ኂ","ኃ","ኄ","ኅ","ኆ","ኈ"], "ነ" : ["ነ","ኑ","ኒ","ና","ኔ","ን","ኖ","ኗ"], "ኘ" : ["ኘ","ኙ","ኚ","ኛ","ኜ","ኝ","ኞ","ኟ"], "አ" : ["አ","ኡ","ኢ","ኣ","ኤ","እ","ኦ","ኧ"],"ከ" : ["ከ","ኩ","ኪ","ካ","ኬ","ክ","ኮ","ኰ"], "ኸ" : ["ኸ","ኹ","ኺ","ኻ","ኼ","ኽ","ኾ"], "ወ" : ["ወ","ዉ","ዊ","ዋ","ዌ","ው","ዎ","ዏ"], "ዐ" : ["ዐ","ዑ","ዒ","ዓ","ዔ","ዕ","ዖ"], "ዘ" : ["ዘ","ዙ","ዚ","ዛ","ዜ","ዝ","ዞ","ዟ"], "ዠ" : ["ዠ","ዡ","ዢ","ዣ","ዤ","ዥ","ዦ","ዧ"], "የ" : ["የ","ዩ","ዪ","ያ","ዬ","ይ","ዮ","ዯ"],"ደ" : ["ደ","ዱ","ዲ","ዳ","ዴ","ድ","ዶ","ዷ"], "ዸ" : ["ዸ","ዹ","ዺ","ዻ","ዼ","ዽ","ዾ","ዿ"], "ጀ" : ["ጀ","ጁ","ጂ","ጃ","ጄ","ጅ","ጆ","ጇ"], "ገ" : ["ገ","ጉ","ጊ","ጋ","ጌ","ግ","ጎ","ጐ"], "ጘ" : ["ጘ","ጙ","ጚ","ጛ","ጜ","ጝ","ጞ","ጟ"], "ጠ" : ["ጠ","ጡ","ጢ","ጣ","ጤ","ጥ","ጦ","ጧ"], "ጨ" : ["ጨ","ጩ","ጪ","ጫ","ጬ","ጭ","ጮ","ጯ"],"ጰ" : ["ጰ","ጱ","ጲ","ጳ","ጴ","ጵ","ጶ","ጷ"], "ጸ" : ["ጸ","ጹ","ጺ","ጻ","ጼ","ጽ","ጾ","ጿ"],"ፀ" : ["ፀ","ፁ","ፂ","ፃ","ፄ","ፅ","ፆ","ፇ"], "ፈ" : ["ፈ","ፉ","ፊ","ፋ","ፌ","ፍ","ፎ","ፏ"],"ፐ" : ["ፐ","ፑ","ፒ","ፓ","ፔ","ፕ","ፖ","ፗ"]]
    
    //MARK: Methods
  
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createKeyboardKeys(1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // adjust the height of the keyboard view to show extended keys
        // custom keyboard doesnt allow showing a view outside of the keyboard view
        let expandedHeight:CGFloat!
        
        if(self.view.frame.size.width == 320) {
           expandedHeight = 220
        } else {
         expandedHeight = 180
        }
        
        let heightConstraint = NSLayoutConstraint(item:self.view,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 0.0,
            constant: expandedHeight)
        self.view.addConstraint(heightConstraint)
    }
    
    // function to add individual keyboard keys
     func createButtonWithTitle(title: String) -> UIButton {
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setTitle(title, forState: .Normal)
        button.sizeToFit()
        button.titleLabel?.font = font
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        button.layer.cornerRadius = 8
        
        if(title == "ext") {
           button.backgroundColor = .None
           button.setImage(UIImage(named: "extendIcon.png"), forState: .Normal)
           button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
           button.tintColor = UIColor.lightGrayColor()
        }
        if(title == "bc") {
           button.backgroundColor = .None
           button.setImage(UIImage(named: "backspaceIcon.png"), forState: .Normal)
           button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
           button.tintColor = UIColor.lightGrayColor()
        }
        
        button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPress:")
        //longPress.delaysTouchesBegan = true
        longPress.minimumPressDuration = 0.5
        button.addGestureRecognizer(longPress)
        return button
    }
    
    //longpress action
    func didLongPress(sender: AnyObject?) {
        let gesture = sender as! UIGestureRecognizer
        let button:UIButton  = gesture.view as! UIButton
        
        if(gesture.state == UIGestureRecognizerState.Began) {
           if((letterRow.indexForKey((button.titleLabel?.text)!)) != nil) {
               let buttonTitleTop = letterRow[(button.titleLabel?.text)!]
               var t1:[NSString] = []
               var t2:[NSString] = []
            
               for i in 0...3 {
                 t1.append(buttonTitleTop![i])
               }
               for i in 4...buttonTitleTop!.count-1 {
                t2.append(buttonTitleTop![i])
               }
            
               exrow1 = self.createExtendedRowsOfButtons(t1)
               exrow2 = self.createExtendedRowsOfButtons(t2)
               self.view.addSubview(exrow1)
               self.view.addSubview(exrow2)
               exrow1.translatesAutoresizingMaskIntoConstraints = false
               exrow2.translatesAutoresizingMaskIntoConstraints = false
               self.addconstrantsToExtendedView(self.view, extendedViews: [exrow1,exrow2], buttonView: button)
            }
         } else if(gesture.state == UIGestureRecognizerState.Ended) {
           exrow1.removeFromSuperview()
           exrow2.removeFromSuperview()
         }
     }
    
      // action for key press
     func didTapButton(sender: AnyObject?) {
        let button = sender as! UIButton
        button.titleLabel?.font = font
        let title = button.titleForState(.Normal)!
        
        switch title {
            
        case "ext" :
            self.createKeyboardKeys(2)
            
        case "ሀለመ" :
            self.createKeyboardKeys(1)
            
        case "!123" :
        self.createKeyboardKeys(3)
            
        case "bc" :
            (textDocumentProxy as UIKeyInput).deleteBackward()
            
        case "RETURN" :
        (textDocumentProxy as UIKeyInput).insertText("\n")
            
        case "SPACE" :
        (textDocumentProxy as UIKeyInput).insertText(" ")

        case "CHG" :
            
         self.advanceToNextInputMode()
            
        default :
            (textDocumentProxy as UIKeyInput).insertText(title)
        }
        
        UIView.animateWithDuration(0.2, animations: {
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0)
            }, completion: {(_) -> Void in
               button.transform =
                CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        })
    }
    
    
    func addIndividualButtonConstraints(buttons: [UIButton], mainView: UIView){
        for (index, button) in buttons.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 1)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -1)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -1)
                
            } else {
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -4)
           }
            
            var leftConstraint : NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: 1)
                
             } else {
                
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: 1)
                
                let firstButton = buttons[0]
                let widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func createRowOfButtons(buttonTitles: [NSString])-> UIView {
       var buttons = [UIButton]()
       let keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))
    
        for buttonTitle in buttonTitles{
           let button = createButtonWithTitle(buttonTitle as String)
           buttons.append(button)
           keyboardRowView.addSubview(button)
       }
       addIndividualButtonConstraints(buttons, mainView: keyboardRowView)
       return keyboardRowView
    }
    
    
    func createExtendedRowsOfButtons(buttonTitles: [NSString])-> UIView  {
        var buttons = [UIButton]()
        let extendedRowView = UIView(frame: CGRectMake(0, 0, 160, 30))
        extendedRowView.backgroundColor = UIColor.whiteColor()
        
        for buttonTitle in buttonTitles{
            let button = createButtonWithTitle(buttonTitle as String)
            buttons.append(button)
            extendedRowView.addSubview(button)
        }
        
        addIndividualButtonConstraints(buttons, mainView: extendedRowView)
        return extendedRowView
    }
    
    
    func addconstrantsToExtendedView(inputView:UIView, extendedViews:[UIView], buttonView:UIButton) {
        for (index, extendedView) in extendedViews.enumerate() {
            var leftConstraint: NSLayoutConstraint
            
            if(buttonView.frame.origin.x < 160 ) {
               leftConstraint = NSLayoutConstraint(item: extendedView, attribute: .Left, relatedBy: .Equal, toItem: buttonView, attribute: .Left, multiplier: 1.0, constant: 1)
            } else {
                 leftConstraint = NSLayoutConstraint(item: extendedView, attribute: .Right, relatedBy: .Equal, toItem: buttonView, attribute: .Right, multiplier: 1.0, constant: 1)
            }
            
            inputView.addConstraints([leftConstraint])
            
            if(index != 0) {
               let prevRow = extendedViews[index-1]
               let topConstraint = NSLayoutConstraint(item: extendedView, attribute: .Top, relatedBy: .Equal, toItem: prevRow, attribute: .Bottom, multiplier: 1.0, constant: 10)
               let firstRow = extendedViews[0]
               let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .Height, relatedBy: .Equal, toItem: extendedView, attribute: .Height, multiplier: 1.0, constant: 0)
               inputView.addConstraint(heightConstraint)
               inputView.addConstraint(topConstraint)
            }
            
            var bottomConstraint: NSLayoutConstraint
            
            if index == extendedViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: extendedView, attribute: .Bottom, relatedBy: .Equal, toItem: buttonView, attribute: .Top, multiplier: 1.0, constant: 0)
            } else {
                let nextRow = extendedViews[index+1]
                bottomConstraint = NSLayoutConstraint(item: extendedView, attribute: .Bottom, relatedBy: .Equal, toItem: nextRow, attribute: .Top, multiplier: 1.0, constant: 0)
            }
            
            inputView.addConstraint(bottomConstraint)
        }
    }
    
    func addConstraintsToInputView(inputView: UIView, rowViews: [UIView]){
        
        for (index, rowView) in rowViews.enumerate() {
            let rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .Right, relatedBy: .Equal, toItem: inputView, attribute: .Right, multiplier: 1.0, constant: -1)
            
            let leftConstraint = NSLayoutConstraint(item: rowView, attribute: .Left, relatedBy: .Equal, toItem: inputView, attribute: .Left, multiplier: 1.0, constant: 1)
            
            inputView.addConstraints([leftConstraint, rightSideConstraint])
            var topConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: inputView, attribute: .Top, multiplier: 1.0, constant: 60)
            } else {
                let prevRow = rowViews[index-1]
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: prevRow, attribute: .Bottom, multiplier: 1.0, constant: 10)
                
                let firstRow = rowViews[0]
                let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .Height, relatedBy: .Equal, toItem: rowView, attribute: .Height, multiplier: 1.0, constant: 0)
                
                inputView.addConstraint(heightConstraint)
            }
            
            inputView.addConstraint(topConstraint)
            var bottomConstraint: NSLayoutConstraint
            
            if index == rowViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: inputView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            } else {
                let nextRow = rowViews[index+1]
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: nextRow, attribute: .Top, multiplier: 1.0, constant: 0)
            }
            
            inputView.addConstraint(bottomConstraint)
        }
    }
    
    
    func createKeyboardKeys(keySet:Int){
        var buttonTitleTop, buttonTitleMiddle, buttonTitleMiddle1 ,buttonTitleBottom , buttonTitlesFunc : [NSString]
        
        if(keySet == 1){
             buttonTitleTop = ["ሀ", "ለ", "ሐ", "መ", "ሠ", "ረ", "ሰ", "ሸ", "ቀ","በ"]
             buttonTitleMiddle = [ "ተ","ቸ", "ኀ", "ነ","ኘ", "አ", "ከ", "ኸ","ወ", "ዐ"]
             buttonTitleMiddle1 = ["ዘ", "ዠ","የ", "ደ", "ዸ", "ጀ", "ገ", "ጠ", "ጨ", "ጰ"]
             buttonTitleBottom = ["ext","ጸ","ፀ", "ፈ","ፐ","ቐ","በ","ጘ","bc"]
             buttonTitlesFunc = ["!123","CHG", "SPACE", "RETURN"]
        } else if (keySet == 2) {
             buttonTitleTop = ["፠", "፡", "።", "፣", "፤", "፥", "፦", "፧", "፨","!"]
             buttonTitleMiddle = [ "@","/", "|","\u{24}","\u{1F496}","\u{36}", "&","ፙ","ፘ","ⶂ"]
             buttonTitleMiddle1 = ["?", "+","<", ">", "{", "}", "-", ".", ",", "#"]
             buttonTitleBottom = ["ext","=","&", "ዃ","ዄ","ዅ","[","]","bc"]
             buttonTitlesFunc = ["!123","CHG", "SPACE", "RETURN"]
       } else {
             buttonTitleTop = ["1", "2", "3", "4", "5", "6", "7", "8", "9","10"]
             buttonTitleMiddle = [ "፬","፭", "፮", "፯","፰", "፱", "፲", "፳","፴", "፵"]
             buttonTitleMiddle1 = ["፶", "፷","፸", "፹", "፺", "፻", "፼", "፩", "፪", "፫"]
             buttonTitleBottom = ["ext","ጸ","ፀ", "ፈ","ፐ","ቐ","በ","ጘ","bc"]
             buttonTitlesFunc = ["ሀለመ","CHG", "SPACE", "RETURN"]

       }
        row1 = createRowOfButtons(buttonTitleTop)
        row2 = createRowOfButtons(buttonTitleMiddle)
        row3 = createRowOfButtons(buttonTitleMiddle1)
        row4 = createRowOfButtons(buttonTitleBottom)
        let row5 = createRowOfButtons(buttonTitlesFunc)
        
        self.view.addSubview(row1)
        self.view.addSubview(row2)
        self.view.addSubview(row3)
        self.view.addSubview(row4)
        self.view.addSubview(row5)
        
        row1.translatesAutoresizingMaskIntoConstraints = false
        row2.translatesAutoresizingMaskIntoConstraints = false
        row3.translatesAutoresizingMaskIntoConstraints = false
        row4.translatesAutoresizingMaskIntoConstraints = false
        row5.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsToInputView(self.view, rowViews: [row1, row2, row3, row4,row5])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
