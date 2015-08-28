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
        
        var index = 0
        let scenes = scenesR.map({ (dictionary) -> SceneDescription in
            let title = dictionary["title"] as! String
            
            index++
            let codeString = self.codeForIndex(index)
            let actions = dictionary["actions"] as! [String]
            return SceneDescription(title: title, code: codeString, actions: actions)
        })
        
        return Config(isDebug: isDebug, speakText: speakText, scenes: scenes)
    }
    
    private static func plistDictionary() -> NSDictionary {
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)!
    }
    
    private static func codeForIndex(index: Int) -> String {
        let path = NSBundle.mainBundle().pathForResource("source_\(index)", ofType: "html")!
        return try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
    }
}

struct SceneDescription {
    let title : String
    let code : String
    let actions : [String]
}
