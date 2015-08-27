//
//  Config.swift
//  SpriteKitTankTalk
//
//  Created by Francesco Frison on 27/08/2015.
//  Copyright (c) 2015 frison. All rights reserved.
//

import Foundation

typealias GenericDictionary = [String: AnyObject]

struct Config {
    let isDebug : Bool
    let speakText : Bool
    let scenes : [SceneDescription]
    
    static func sharedConfig() -> Config! {
        let configDict = plistDictionary()
        let isDebug = configDict["isDebug"]!.boolValue!
        let speakText = configDict["speakText"]!.boolValue!
        let scenesR = configDict["scenes"] as! [[String : AnyObject]]
        let scenes = scenesR.map({ (dictionary) -> SceneDescription in
            let title = dictionary["title"] as! String
            let codeString = dictionary["code"] as! String
            let codeAttributed = NSAttributedString(htmlString: codeString)
            let actions = dictionary["actions"] as! [String]
            return SceneDescription(title: title, code: codeAttributed!, actions: actions)
        })
        
        return Config(isDebug: isDebug, speakText: speakText, scenes: scenes)
    }
    
    private static func plistDictionary() -> NSDictionary {
        var myDict: NSDictionary?
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)!
    }
}

extension NSAttributedString {
    convenience init?(htmlString: String) {
        let data = htmlString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var error : NSError?
        self.init(data: data!, options: nil, documentAttributes: nil, error: &error)
    }
}

struct SceneDescription {
    let title : String
    let code : NSAttributedString
    let actions : [String]
}
