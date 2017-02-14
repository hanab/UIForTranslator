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
    
    override func viewDidAppear(_ animated: Bool) {
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
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 0.0,
            constant: expandedHeight)
        self.view.addConstraint(heightConstraint)
    }
    
    // function to add individual keyboard keys
     func createButtonWithTitle(_ title: String) -> UIButton {
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setTitle(title, for: UIControlState())
        button.sizeToFit()
        button.titleLabel?.font = font
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGray, for: UIControlState())
        button.layer.cornerRadius = 8
        
        if(title == "ext") {
           button.backgroundColor = .none
           button.setImage(UIImage(named: "extendIcon.png"), for: UIControlState())
           button.setTitleColor(UIColor.white, for: UIControlState())
           button.tintColor = UIColor.lightGray
        }
        if(title == "bc") {
           button.backgroundColor = .none
           button.setImage(UIImage(named: "backspaceIcon.png"), for: UIControlState())
           button.setTitleColor(UIColor.white, for: UIControlState())
           button.tintColor = UIColor.lightGray
        }
        
        button.addTarget(self, action: #selector(KeyboardViewController.didTapButton(_:)), for: .touchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(KeyboardViewController.didLongPress(_:)))
        //longPress.delaysTouchesBegan = true
        longPress.minimumPressDuration = 0.5
        button.addGestureRecognizer(longPress)
        return button
    }
    
    //longpress action
    func didLongPress(_ sender: AnyObject?) {
        let gesture = sender as! UIGestureRecognizer
        let button:UIButton  = gesture.view as! UIButton
        
        if(gesture.state == UIGestureRecognizerState.began) {
           if((letterRow.index(forKey: (button.titleLabel?.text)!)) != nil) {
               let buttonTitleTop = letterRow[(button.titleLabel?.text)!]
               var t1:[NSString] = []
               var t2:[NSString] = []
            
               for i in 0...3 {
                 t1.append(buttonTitleTop![i] as NSString)
               }
               for i in 4...buttonTitleTop!.count-1 {
                t2.append(buttonTitleTop![i] as NSString)
               }
            
               exrow1 = self.createExtendedRowsOfButtons(t1)
               exrow2 = self.createExtendedRowsOfButtons(t2)
               self.view.addSubview(exrow1)
               self.view.addSubview(exrow2)
               exrow1.translatesAutoresizingMaskIntoConstraints = false
               exrow2.translatesAutoresizingMaskIntoConstraints = false
               self.addconstrantsToExtendedView(self.view, extendedViews: [exrow1,exrow2], buttonView: button)
            }
         } else if(gesture.state == UIGestureRecognizerState.ended) {
           exrow1.removeFromSuperview()
           exrow2.removeFromSuperview()
         }
     }
    
      // action for key press
     func didTapButton(_ sender: AnyObject?) {
        let button = sender as! UIButton
        button.titleLabel?.font = font
        let title = button.title(for: UIControlState())!
        
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
        
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
            }, completion: {(_) -> Void in
               button.transform =
                CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        })
    }
    
    
    func addIndividualButtonConstraints(_ buttons: [UIButton], mainView: UIView){
        for (index, button) in buttons.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 1)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: -1)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -1)
                
            } else {
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -4)
           }
            
            var leftConstraint : NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: 1)
                
             } else {
                
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevtButton, attribute: .right, multiplier: 1.0, constant: 1)
                
                let firstButton = buttons[0]
                let widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func createRowOfButtons(_ buttonTitles: [NSString])-> UIView {
       var buttons = [UIButton]()
       let keyboardRowView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    
        for buttonTitle in buttonTitles{
           let button = createButtonWithTitle(buttonTitle as String)
           buttons.append(button)
           keyboardRowView.addSubview(button)
       }
       addIndividualButtonConstraints(buttons, mainView: keyboardRowView)
       return keyboardRowView
    }
    
    
    func createExtendedRowsOfButtons(_ buttonTitles: [NSString])-> UIView  {
        var buttons = [UIButton]()
        let extendedRowView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
        extendedRowView.backgroundColor = UIColor.white
        
        for buttonTitle in buttonTitles{
            let button = createButtonWithTitle(buttonTitle as String)
            buttons.append(button)
            extendedRowView.addSubview(button)
        }
        
        addIndividualButtonConstraints(buttons, mainView: extendedRowView)
        return extendedRowView
    }
    
    
    func addconstrantsToExtendedView(_ inputView:UIView, extendedViews:[UIView], buttonView:UIButton) {
        for (index, extendedView) in extendedViews.enumerated() {
            var leftConstraint: NSLayoutConstraint
            
            if(buttonView.frame.origin.x < 160 ) {
               leftConstraint = NSLayoutConstraint(item: extendedView, attribute: .left, relatedBy: .equal, toItem: buttonView, attribute: .left, multiplier: 1.0, constant: 1)
            } else {
                 leftConstraint = NSLayoutConstraint(item: extendedView, attribute: .right, relatedBy: .equal, toItem: buttonView, attribute: .right, multiplier: 1.0, constant: 1)
            }
            
            inputView.addConstraints([leftConstraint])
            
            if(index != 0) {
               let prevRow = extendedViews[index-1]
               let topConstraint = NSLayoutConstraint(item: extendedView, attribute: .top, relatedBy: .equal, toItem: prevRow, attribute: .bottom, multiplier: 1.0, constant: 10)
               let firstRow = extendedViews[0]
               let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .height, relatedBy: .equal, toItem: extendedView, attribute: .height, multiplier: 1.0, constant: 0)
               inputView.addConstraint(heightConstraint)
               inputView.addConstraint(topConstraint)
            }
            
            var bottomConstraint: NSLayoutConstraint
            
            if index == extendedViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: extendedView, attribute: .bottom, relatedBy: .equal, toItem: buttonView, attribute: .top, multiplier: 1.0, constant: 0)
            } else {
                let nextRow = extendedViews[index+1]
                bottomConstraint = NSLayoutConstraint(item: extendedView, attribute: .bottom, relatedBy: .equal, toItem: nextRow, attribute: .top, multiplier: 1.0, constant: 0)
            }
            
            inputView.addConstraint(bottomConstraint)
        }
    }
    
    func addConstraintsToInputView(_ inputView: UIView, rowViews: [UIView]){
        
        for (index, rowView) in rowViews.enumerated() {
            let rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .right, relatedBy: .equal, toItem: inputView, attribute: .right, multiplier: 1.0, constant: -1)
            
            let leftConstraint = NSLayoutConstraint(item: rowView, attribute: .left, relatedBy: .equal, toItem: inputView, attribute: .left, multiplier: 1.0, constant: 1)
            
            inputView.addConstraints([leftConstraint, rightSideConstraint])
            var topConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .top, relatedBy: .equal, toItem: inputView, attribute: .top, multiplier: 1.0, constant: 60)
            } else {
                let prevRow = rowViews[index-1]
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .top, relatedBy: .equal, toItem: prevRow, attribute: .bottom, multiplier: 1.0, constant: 10)
                
                let firstRow = rowViews[0]
                let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .height, relatedBy: .equal, toItem: rowView, attribute: .height, multiplier: 1.0, constant: 0)
                
                inputView.addConstraint(heightConstraint)
            }
            
            inputView.addConstraint(topConstraint)
            var bottomConstraint: NSLayoutConstraint
            
            if index == rowViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .bottom, relatedBy: .equal, toItem: inputView, attribute: .bottom, multiplier: 1.0, constant: 0)
            } else {
                let nextRow = rowViews[index+1]
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .bottom, relatedBy: .equal, toItem: nextRow, attribute: .top, multiplier: 1.0, constant: 0)
            }
            
            inputView.addConstraint(bottomConstraint)
        }
    }
    
    
    func createKeyboardKeys(_ keySet:Int){
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
