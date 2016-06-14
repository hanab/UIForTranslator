//
//  TokenRequester.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 30/01/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//
// credentials to access microsoft transslator API
let bingAPI = "http://api.microsofttranslator.com"
let bingClientSecret = "nBkVIYGn5zPhMQtRCUPGJETB/K6ByH9sZGjmoahT+oU="
let bingClientCredentials = "grant_type"
let tokenString = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
let bingAPITranslate = "https://api.microsofttranslator.com/v2/Http.svc/Translate?"
let bingAPIDetect = "http://api.microsofttranslator.com/v2/Http.svc/Detect?"
let bingAppId = "4242d89f-9b99-45f8-8957-ef8fb161d448"
let ACCESS_TOKEN_KEY = "access_token_key"
let ACCESS_TOKEN_EXPIRED = "The incoming token has expired. Get a new access token from the Authorization Server."
let category = "2e34a21e-4bfa-4a15-b8e4-f14d91c9dca5-HANA_GENERAL"

// protocol which will be implemented by MainViewControllerClass
protocol AccessTokenDelegate{
    func translationEroor (ac:AccessTokenRequester, error:String)
    func translatedText(ac:AccessTokenRequester, text:NSString)
    func detectedLanguage(ac:AccessTokenRequester, lan:NSString)
}

import Foundation

// class to access microsoft translator api
class AccessTokenRequester : NSObject {
    
    //MARK: properties
    
    let session = NSURLSession.sharedSession()
    var delegate:AccessTokenDelegate?
    let url = NSURL(string: tokenString)
    var accessToken:NSString = ""
    var receivedData:NSMutableData?
    var translateConnection:NSURLConnection?
    var detectConnection:NSURLConnection?
    
    //MARK: methods
    
    func getValueAccessToken()->NSString{
        if( NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN_KEY) != nil){
            return NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN_KEY)!
        } else {
            return("error")
        }
    }
    
    func getAccessToken()-> Bool {
        var isSuccess:Bool = false
        let customAllowedSet =  NSCharacterSet(charactersInString:"!*'();:@&=+$,/?%#[]").invertedSet
        let clientSecret:String = bingClientSecret.stringByAddingPercentEncodingWithAllowedCharacters(
            customAllowedSet)!
        
        var authHeader:String = "client_id="
        authHeader += ( bingAppId + "&client_secret=" + clientSecret + "&grant_type=client_credentials&scope=http://api.microsofttranslator.com" )
        
        let requestAuTh:NSMutableURLRequest = NSMutableURLRequest.init(URL: url!, cachePolicy:
            .ReloadRevalidatingCacheData
            , timeoutInterval: 60.0)
        
        requestAuTh.HTTPMethod = "POST"
        requestAuTh.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestAuTh.HTTPBody =  authHeader.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(requestAuTh, completionHandler: {data, response, error -> Void in
            if error != nil {
                print(error)
            } else {
            if(data != nil) {
                let contents:NSString = NSString.init(data: data!, encoding: NSUTF8StringEncoding)!
                let formattedContents:NSString = contents.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                print("formattedContents = \(formattedContents) ")
                
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    self.accessToken = (jsonResult.objectForKey("access_token") as? NSString)!
                    print("accessToken = %@", self.accessToken)
                    if (self.accessToken.length > 0 ) {
                        isSuccess = true
                    } else {
                        self.accessToken = ""
                    }
                } catch {
                        print("error serializing JSON: \(error)")
                }
            }
         }
            
         })
        
        task.resume()
        
        NSUserDefaults.standardUserDefaults().setObject(self.accessToken, forKey: ACCESS_TOKEN_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
       return isSuccess
    }
    
    func clearAccessToken() {
        NSUserDefaults.standardUserDefaults().setObject("", forKey: ACCESS_TOKEN_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func checkAndGetAccessToken()->Bool {
        if((self.getValueAccessToken()).length < 1){
            if(!(self.getAccessToken())) {
                delegate?.translationEroor(self, error: "get Access Token error")
                return false
            }
        }
        return true
    }
    
    func showEroor(error:String) {
        delegate?.translationEroor(self, error: error)
    }
    
    func traslateTextFromSourceToTarget(text: NSString, sourceLan: NSString, TargetLan: NSString) {
         print(self.checkAndGetAccessToken())
         if(!(self.checkAndGetAccessToken())) {
            delegate?.translatedText(self, text: "token not found")
            return
         }
         if(receivedData != nil) {
            receivedData = nil
         }
        
         receivedData = NSMutableData()
         let encodedString:NSString = text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
         let string_prefix:NSString = bingAPITranslate + "&text="
         var string_suffix:NSString = ""
        
         if(sourceLan.length > 1) {
            string_suffix = (string_suffix as String) + String("&from=\(sourceLan)&to=\(TargetLan)&category=")
            string_suffix = (string_suffix as String) + category
         } else {
            string_suffix.stringByAppendingString("&to=\(TargetLan)&category=")
            string_suffix = (string_suffix as String) + category
        }
        
        let finalString:String = (string_prefix as String) + (encodedString as String) + (string_suffix as String)
        let url = NSURL(string: finalString)
        let request:NSMutableURLRequest = NSMutableURLRequest.init(URL: url!)
        request.addValue("Bearer \(self.getValueAccessToken())", forHTTPHeaderField: "Authorization")
        if(translateConnection != nil) {
            translateConnection = nil
        }
        translateConnection = NSURLConnection.init(request: request, delegate: self)
    }
    
    func initWithDelegateAndTranslatFromSourceToTarget(del:AccessTokenDelegate?, text:NSString, sourceLan:NSString, targetLan:NSString) {
        delegate = del
        self.traslateTextFromSourceToTarget(text, sourceLan: sourceLan, TargetLan: targetLan)
    }
    
    func detectLanguageForText(text:NSString) {
        if(text.length < 1 ) {
            return
        }
        if(!(self.checkAndGetAccessToken())) {
            return
        }
        if(receivedData != nil ) {
            receivedData = nil
        }
        receivedData = NSMutableData()
        
        let encodedString = text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let string_prefix:NSString = bingAPIDetect + "&text="
        let finalString:String = (string_prefix as String) + (encodedString as String)
        let url = NSURL(string: finalString)
        let request:NSMutableURLRequest = NSMutableURLRequest.init(URL: url!)
        request.addValue("Bearer \(self.getValueAccessToken())", forHTTPHeaderField: "Authorization")
        if(detectConnection != nil) {
            detectConnection = nil
        }
        detectConnection = NSURLConnection.init(request: request, delegate: self)
    }
    
    func initWithDelegateAndDetectLanguageForText(del:AccessTokenDelegate ,text:NSString) {
        if(text.length < 1) {
           return
         }
        self.delegate = del
        self.detectLanguageForText(text)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        receivedData?.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Translator fail : \(error.localizedDescription)")
        delegate?.translationEroor(self, error: "\(error.localizedDescription)")
        if(connection == translateConnection) {
            translateConnection = nil
        } else {
            detectConnection = nil
        }
        receivedData = nil
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        let recieved_text:NSString? = NSString.init(data: receivedData!, encoding: NSUTF8StringEncoding)
        if(recieved_text != nil ) {
            if(recieved_text!.rangeOfString(ACCESS_TOKEN_EXPIRED).location != NSNotFound) {
                self.getAccessToken()
                delegate?.translationEroor(self, error: ACCESS_TOKEN_EXPIRED)
                return
            }
            
            let parts:NSArray = (recieved_text!.componentsSeparatedByString("/Serialization/\">"))
            if(parts.count < 2) {
                delegate?.translationEroor(self, error: "not a valid language")
                print(self.getAccessToken())
            } else {
                var toReturn:NSString = parts.objectAtIndex(1) as! NSString
                toReturn = toReturn.stringByReplacingOccurrencesOfString("</string>", withString: "")
                if (connection == translateConnection){
                    delegate?.translatedText(self, text: toReturn)
                } else {
                    delegate?.detectedLanguage(self, lan: toReturn)
                }
                
             }
            
           }
        
          receivedData = nil
          if (connection == translateConnection){
            translateConnection = nil
          }  else {
            detectConnection = nil
          }
    }
}

