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
            let actions = dictionary["actions"] as! [String]
            return SceneDescription(title: title, code: codeString, actions: actions)
        })
        
        return Config(isDebug: isDebug, speakText: speakText, scenes: scenes)
    }
    
    private static func plistDictionary() -> NSDictionary {
        var myDict: NSDictionary?
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)!
    }
}

struct SceneDescription {
    let title : String
    let code : String
    let actions : [String]
}
