//
//  LocalData.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 06/11/23.
//

import Foundation

class LocalData {
    public static let language = "AppleLanguages"
    
    class func saveLanguage(_ value :String,_ key:String) {
        var appleLanguages = UserDefaults.standard.object(forKey: self.language) as! [String]
        if appleLanguages.count > 0 {
        appleLanguages.remove(at: 0)
        appleLanguages.insert(value, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: self.language)
        }
    }
    
    class func getLanguage(_ key:String) -> String {
        let appleLanguages = UserDefaults.standard.object(forKey: self.language) as! [String]
        if appleLanguages.count > 0 {
        let prefferedLanguage = appleLanguages[0]
        if prefferedLanguage.contains("-") {
            let array = prefferedLanguage.components(separatedBy: "-")
            return array[0]
        }
        return prefferedLanguage
        }
        return "en"
    }

}
