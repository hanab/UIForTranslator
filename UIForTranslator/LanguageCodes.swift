//
//  LanguageCodes.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 11/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import Foundation
import UIKit

class LanguageCodes : NSObject {
    
    //MARK: Properties
    
    private var name:String
    private var langCode:String
    private var flag:UIImage
    
    //MARK: init
    
    init(name:String, langCode:String, flag:UIImage) {
        self.name = name
        self.langCode = langCode
        self.flag = flag
    }
    
    //MARK:Methods

    func getLangName()->String {
         return self.name
    }
    
    func getLangCode()->String {
        return self.langCode
    }

    func getFlag()->UIImage {
        return self.flag
    }
    
}