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
    func translationEroor (_ ac:AccessTokenRequester, error:String)
    func translatedText(_ ac:AccessTokenRequester, text:NSString)
    func detectedLanguage(_ ac:AccessTokenRequester, lan:NSString)
}

import Foundation

// class to access microsoft translator api
class AccessTokenRequester : NSObject {
    
    //MARK: properties
    
    let session = URLSession.shared
    var delegate:AccessTokenDelegate?
    let url = URL(string: tokenString)
    var accessToken:NSString = ""
    var receivedData:NSMutableData?
    var translateConnection:NSURLConnection?
    var detectConnection:NSURLConnection?
    
    //MARK: methods
    
    func getValueAccessToken()->NSString{
        if( UserDefaults.standard.string(forKey: ACCESS_TOKEN_KEY) != nil){
            return UserDefaults.standard.string(forKey: ACCESS_TOKEN_KEY)! as NSString
        } else {
            return("error")
        }
    }
    
    func getAccessToken()-> Bool {
        var isSuccess:Bool = false
        let customAllowedSet =  CharacterSet(charactersIn:"!*'();:@&=+$,/?%#[]").inverted
        let clientSecret:String = bingClientSecret.addingPercentEncoding(
            withAllowedCharacters: customAllowedSet)!
        
        var authHeader:String = "client_id="
        authHeader += ( bingAppId + "&client_secret=" + clientSecret + "&grant_type=client_credentials&scope=http://api.microsofttranslator.com" )
        
        var requestAuTh:URLRequest = URLRequest.init(url: url!, cachePolicy:
            .reloadRevalidatingCacheData
            , timeoutInterval: 60.0)
        
        requestAuTh.httpMethod = "POST"
        requestAuTh.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestAuTh.httpBody =  authHeader.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: requestAuTh) {
            data, response, error in
            if error != nil {
                print(error ?? "sorry")
            } else {
            if(data != nil) {
                let contents:NSString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)!
                let formattedContents:NSString = contents.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                print("formattedContents = \(formattedContents) ")
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    self.accessToken = (jsonResult.object(forKey: "access_token") as? NSString)!
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
            
         }.resume()
        
        UserDefaults.standard.set(self.accessToken, forKey: ACCESS_TOKEN_KEY)
        UserDefaults.standard.synchronize()
       return isSuccess
    }
    
    func clearAccessToken() {
        UserDefaults.standard.set("", forKey: ACCESS_TOKEN_KEY)
        UserDefaults.standard.synchronize()
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
    
    func showEroor(_ error:String) {
        delegate?.translationEroor(self, error: error)
    }
    
    func traslateTextFromSourceToTarget(_ text: NSString, sourceLan: NSString, TargetLan: NSString) {
         print(self.checkAndGetAccessToken())
         if(!(self.checkAndGetAccessToken())) {
            delegate?.translatedText(self, text: "Translating .....")
            return
         }
         if(receivedData != nil) {
            receivedData = nil
         }
        
         receivedData = NSMutableData()
         let encodedString:NSString = text.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as String as NSString
         let string_prefix:NSString = (bingAPITranslate + "&text=") as NSString
         var string_suffix:NSString = ""
        
         if(sourceLan.length > 1) {
            string_suffix = ((string_suffix as String) + String("&from=\(sourceLan)&to=\(TargetLan)&category=")) as NSString
            string_suffix = ((string_suffix as String) + category) as NSString
         } else {
            string_suffix.appending("&to=\(TargetLan)&category=")
            string_suffix = ((string_suffix as String) + category) as NSString
        }
        
        let finalString:String = (string_prefix as String) + (encodedString as String) + (string_suffix as String)
        let url = URL(string: finalString)
        let request:NSMutableURLRequest = NSMutableURLRequest.init(url: url!)
        request.addValue("Bearer \(self.getValueAccessToken())", forHTTPHeaderField: "Authorization")
        if(translateConnection != nil) {
            translateConnection = nil
        }
        translateConnection = NSURLConnection.init(request: request as URLRequest, delegate: self)
    }
    
    func initWithDelegateAndTranslatFromSourceToTarget(_ del:AccessTokenDelegate?, text:NSString, sourceLan:NSString, targetLan:NSString) {
        delegate = del
        self.traslateTextFromSourceToTarget(text, sourceLan: sourceLan, TargetLan: targetLan)
    }
    
    func detectLanguageForText(_ text:NSString) {
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
        
        let encodedString = text.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let string_prefix:NSString = (bingAPIDetect + "&text=") as NSString
        let finalString:String = (string_prefix as String) + (encodedString as String)
        let url = URL(string: finalString)
        let request:NSMutableURLRequest = NSMutableURLRequest.init(url: url!)
        request.addValue("Bearer \(self.getValueAccessToken())", forHTTPHeaderField: "Authorization")
        if(detectConnection != nil) {
            detectConnection = nil
        }
        detectConnection = NSURLConnection.init(request: request as URLRequest, delegate: self)
    }
    
    func initWithDelegateAndDetectLanguageForText(_ del:AccessTokenDelegate ,text:NSString) {
        if(text.length < 1) {
           return
         }
        self.delegate = del
        self.detectLanguageForText(text)
    }
    
    func connection(_ connection: NSURLConnection, didReceiveData data: Data) {
        receivedData?.append(data)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: NSError) {
        print("Translator fail : \(error.localizedDescription)")
        delegate?.translationEroor(self, error: "\(error.localizedDescription)")
        if(connection == translateConnection) {
            translateConnection = nil
        } else {
            detectConnection = nil
        }
        receivedData = nil
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        let recieved_text:NSString? = NSString.init(data: receivedData! as Data, encoding: String.Encoding.utf8.rawValue)
        if(recieved_text != nil ) {
            if(recieved_text!.range(of: ACCESS_TOKEN_EXPIRED).location != NSNotFound) {
                self.getAccessToken()
                delegate?.translationEroor(self, error: ACCESS_TOKEN_EXPIRED)
                return
            }
            
            let parts:NSArray = ((recieved_text!.components(separatedBy: "/Serialization/\">"))  ) as NSArray
            if(parts.count < 2) {
                delegate?.translationEroor(self, error: "not a valid language")
                print(self.getAccessToken())
            } else {
                var toReturn:NSString = parts.object(at: 1) as! NSString
                toReturn = toReturn.replacingOccurrences(of: "</string>", with: "") as NSString
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

