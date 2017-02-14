//
//  TableViewCellController.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 20/02/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import Foundation
import UIKit

class TableViewCellController: UITableViewCell {
    
    //MARK:Properties
    
    let sourceText = UITextView()
    let sourceImage = UIImageView()
    let targetImage = UIImageView()
    let targetText = UITextView()
    
    //MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //use auto layout
        sourceText.translatesAutoresizingMaskIntoConstraints = false
        sourceImage.translatesAutoresizingMaskIntoConstraints = false
        targetImage.translatesAutoresizingMaskIntoConstraints = false
        targetText.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(sourceText)
        contentView.addSubview(sourceImage)
        contentView.addSubview(targetImage)
        contentView.addSubview(targetText)
        
        let viewsDict = [
            "sText" : sourceText,
            "sImage" : sourceImage,
            "tImage" : targetImage,
            "tText" : targetText,
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[sText(20)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[tText(30)]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[sImage]-[tImage]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[sImage]-[sText]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tImage]-[tText]-|", options: [], metrics: nil, views: viewsDict))
    }

}
